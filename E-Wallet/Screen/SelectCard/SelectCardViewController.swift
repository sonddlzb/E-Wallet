//
//  SelectCardViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 19/04/2023.
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    static let cellSpacing = 12.0
    static let cellHeight = 60.0
}

protocol SelectCardPresentableListener: AnyObject {
    func didTapCancelButton()
    func didSelectAt(indexPath: IndexPath)
    func didSelectAddNewCard()
}

final class SelectCardViewController: UIViewController, SelectCardViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Variables
    weak var listener: SelectCardPresentableListener?
    private var viewModel = CardViewModel.makeEmpty()
    private var selectedCard: Card?
    private var balance = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    private func config() {
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = Const.contentInset
        self.collectionView.registerCell(type: PaymentMethodCell.self)
    }

    // MARK: - Actions
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.listener?.didTapCancelButton()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SelectCardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfAccounts() + 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: PaymentMethodCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        if indexPath.row == self.viewModel.numberOfAccounts() + 1 {
            cell.bindAddCell(isFullVersion: true)
        } else if indexPath.row == 0 {
            cell.bind(balance: self.balance, isSelected: self.selectedCard == nil, isFullVersion: true)
        } else {
            let itemViewModel = self.viewModel.item(at: indexPath.row - 1)
            cell.bind(itemViewModel: itemViewModel, isSelected: itemViewModel.card.id == self.selectedCard?.id, isFullVersion: true)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.selectedCard = nil
            self.collectionView.reloadData()
            self.listener?.didSelectAt(indexPath: indexPath)
        } else if indexPath.row < self.viewModel.numberOfAccounts() + 1 {
            self.selectedCard = self.viewModel.listCards[indexPath.row-1]
            self.collectionView.reloadData()
            self.listener?.didSelectAt(indexPath: indexPath)
        } else {
            self.listener?.didSelectAddNewCard()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SelectCardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width - Const.contentInset.left - Const.contentInset.right
        let height = Const.cellHeight
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }
}

// MARK: - SelectCardPresentable
extension SelectCardViewController: SelectCardPresentable {
    func bind(viewModel: CardViewModel, balance: Double) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.balance = balance
        self.collectionView.reloadData()
    }

    func bindSelectedCard(_ selectedCard: Card?) {
        self.selectedCard = selectedCard
        self.loadViewIfNeeded()
        self.collectionView.reloadData()
    }
}
