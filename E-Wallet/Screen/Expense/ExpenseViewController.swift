//
//  ExpenseViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 15/05/2023.
//

import RIBs
import RxSwift
import UIKit
import Charts

private struct Const {
    static let columnSpacing = 10.0
    static let contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    static let cellHeight = 70.0
    static let cellSpacing = 6.0
    static let footerHeight = 520.0
}

protocol ExpensePresentableListener: AnyObject {
    func didTapBack()
}

final class ExpenseViewController: UIViewController, ExpenseViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var expenseBarView: ExpenseBarView!
    @IBOutlet private weak var expenseBarTopConstraint: NSLayoutConstraint!

    // MARK: - Variables
    weak var listener: ExpensePresentableListener?
    var viewModel = ExpenseViewModel.makeEmpty()
    private var headerView: ExpenseHeaderView?
    private var isOnExpenseMode: Bool = true

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.configCollectionView()
        self.expenseBarView.delegate = self
    }

    private func configCollectionView() {
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInset = Const.contentInset
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerCell(type: HistoryCell.self)
        self.collectionView.register(ExpenseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ExpenseHeaderView")
    }

    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.didTapBack()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ExpenseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: HistoryCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        cell.bind(itemViewModel: self.isOnExpenseMode ? self.viewModel.expenseItem(at: indexPath.row) : self.viewModel.incomeItem(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isOnExpenseMode ? self.viewModel.numberOfExpenseTransactions() : self.viewModel.numberOfIncomeTransactions()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ExpenseHeaderView", for: indexPath) as? ExpenseHeaderView else {
            return UICollectionReusableView()
        }

        footerView.bind(viewModel: self.viewModel)

        footerView.delegate = self
        return footerView
    }
}

// MARK: - ExpensePresentable
extension ExpenseViewController: ExpensePresentable {
    func bind(viewModel: ExpenseViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.collectionView.reloadData()
        self.headerView?.bind(viewModel: viewModel)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ExpenseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right
        let height = Const.cellHeight
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right
        let height = Const.footerHeight
        return CGSize(width: width, height: height)
    }
}

// MARK: - ExpenseHeaderViewDelegate
extension ExpenseViewController: ExpenseHeaderViewDelegate {
    func expenseHeaderView(_ expenseHeaderView: ExpenseHeaderView, didSelect entry: Charts.ChartDataEntry) {
        print("select entry \(entry)")
    }
}

// MARK: - ExpenseBarViewDelegate
extension ExpenseViewController: ExpenseBarViewDelegate {
    func expenseBarViewDidSelectExpense(_ expenseBarView: ExpenseBarView) {
        self.isOnExpenseMode = true
        self.collectionView.reloadData()
    }

    func expenseBarViewDidSelectIncome(_ expenseBarView: ExpenseBarView) {
        self.isOnExpenseMode = false
        self.collectionView.reloadData()
    }
}

// MARK: - UIScrollViewDelegate
extension ExpenseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.expenseBarTopConstraint.constant = max(0.0, 450.0 - scrollView.contentOffset.y)
    }
}
