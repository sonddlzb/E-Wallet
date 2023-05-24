//
//  ExpenseHeaderView.swift
//  E-Wallet
//
//  Created by đào sơn on 22/05/2023.
//

import Foundation
import Charts

protocol ExpenseHeaderViewDelegate: AnyObject {
    func expenseHeaderView(_ expenseHeaderView: ExpenseHeaderView, didSelect entry: ChartDataEntry)
}

class ExpenseHeaderView: UICollectionReusableView {
    private var containerView: UIView!
    private var chartView: BarChartView!

    weak var delegate: ExpenseHeaderViewDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        self.config()
        self.addContentViews()
        self.addLayoutConstraints()
    }

    // MARK: - Config
    private func config() {
        self.containerView = UIView()
        self.containerView.translatesAutoresizingMaskIntoConstraints = false

        self.chartView = BarChartView()
        self.chartView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addContentViews() {
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.chartView)
    }

    private func addLayoutConstraints() {
        self.containerView.fitSuperviewConstraint()

        NSLayoutConstraint.activate([
            self.chartView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.chartView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.chartView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.chartView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -90.0)
        ])
    }

    func bind(viewModel: ExpenseViewModel) {
        viewModel.fetchListMonthsTotalMoney { monthlyData in
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
            self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: viewModel.listMonths())
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
}

// MARK: - ChartViewDelegate
extension ExpenseHeaderView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        self.delegate?.expenseHeaderView(self, didSelect: entry)
    }
}
