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
}

protocol ExpensePresentableListener: AnyObject {
    func didTapBack()
}

final class ExpenseViewController: UIViewController, ExpenseViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var expenseBarView: ExpenseBarView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var chartView: BarChartView!
    @IBOutlet private weak var scrollView: UIScrollView!

    // MARK: - Variables
    weak var listener: ExpensePresentableListener?
    var viewModel = ExpenseViewModel.makeEmpty()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.configExpenseBarView()
        self.configCollectionView()
    }

    private func configExpenseBarView() {
        self.expenseBarView.delegate = self
    }

    private func configCollectionView() {
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInset = Const.contentInset
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerCell(type: HistoryCell.self)
    }

    private func bindChartData() {
        self.viewModel.fetchListMonthsTotalMoney { monthlyData in
            var barEntries: [BarChartDataEntry] = []
            let currencyFormatter = NumberFormatter()
            currencyFormatter.numberStyle = .currency
            currencyFormatter.currencySymbol = "$"
            currencyFormatter.maximumFractionDigits = 2
            for index in 0..<monthlyData.count {
                let entry = BarChartDataEntry(x: Double(index), y: monthlyData[index])
                barEntries.append(entry)
            }

            let barDataSet = BarChartDataSet(entries: barEntries, label: "Total Expense")
            let barData = BarChartData(dataSet: barDataSet)

            self.chartView.data = barData
            self.chartView.xAxis.labelPosition = .bottom
            self.chartView.xAxis.labelCount = monthlyData.count
            self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.viewModel.listMonths())
            self.chartView.leftAxis.valueFormatter = (DefaultAxisValueFormatter(formatter: currencyFormatter))
            self.chartView.rightAxis.valueFormatter = (DefaultAxisValueFormatter(formatter: currencyFormatter))
            self.chartView.barData?.setValueFormatter(DefaultValueFormatter(formatter: currencyFormatter))

            self.chartView.xAxis.drawGridLinesEnabled = false
            self.chartView.leftAxis.drawGridLinesEnabled = false
            self.chartView.rightAxis.drawGridLinesEnabled = false
            self.chartView.xAxis.axisMinimum = -0.5
            self.chartView.tintColor = .crayola
            self.chartView.legend.yEntrySpace = 10.0
            self.chartView.delegate = self

            self.chartView.notifyDataSetChanged()
        }
    }

    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.didTapBack()
    }
}

// MARK: - ChartViewDelegate
extension ExpenseViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("select entry \(entry)")
    }
}

// MARK: - ExpenseBarViewDelegate
extension ExpenseViewController: ExpenseBarViewDelegate {
    func expenseBarViewDidSelectExpense(_ expenseBarView: ExpenseBarView) {
        self.collectionView.reloadData()
    }

    func expenseBarViewDidSelectIncome(_ expenseBarView: ExpenseBarView) {
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ExpenseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueCell(type: HistoryCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        cell.bind(itemViewModel: self.expenseBarView.isOnExpenseMode ? self.viewModel.expenseItem(at: indexPath.row) : self.viewModel.incomeItem(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.expenseBarView.isOnExpenseMode ? self.viewModel.numberOfExpenseTransactions() : self.viewModel.numberOfIncomeTransactions()
    }
}

// MARK: - ExpensePresentable
extension ExpenseViewController: ExpensePresentable {
    func bind(viewModel: ExpenseViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.collectionView.reloadData()
        self.bindChartData()
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
}
