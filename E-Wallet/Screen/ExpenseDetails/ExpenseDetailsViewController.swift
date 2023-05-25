//
//  ExpenseDetailsViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 24/05/2023.
//

import RIBs
import RxSwift
import UIKit
import Charts

protocol ExpenseDetailsPresentableListener: AnyObject {
    func didTapBack()
}

final class ExpenseDetailsViewController: UIViewController, ExpenseDetailsViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var highestLabel: UILabel!
    @IBOutlet private weak var chartView: PieChartView!

    // MARK: - Variables
    weak var listener: ExpenseDetailsPresentableListener?
    var viewModel = ExpenseDetailsViewModel.makeEmpty()
    var currentText = "Welcome you to expense management feature in E-Wallet!"
    var currentIndex = 0
    var timer: Timer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
//        showNextCharacter()
    }

    private func config() {
        self.chartView.delegate = self
    }

    func resetBubbleChat() {
        self.timer?.invalidate()
        self.messageLabel.text = ""
    }

    func showNextCharacter() {
        guard currentIndex < currentText.count - 1 else {
             // Khi đã hiển thị hết ký tự, dừng timer
             timer?.invalidate()
             return
         }

         let index = currentText.index(currentText.startIndex, offsetBy: currentIndex)
         let nextCharacter = String(currentText[index])

         // Hiển thị ký tự tiếp theo
         messageLabel.text = messageLabel.text! + nextCharacter

         currentIndex += 1

         // Tiếp tục hiển thị ký tự tiếp theo sau 0.1 giây
         timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { [weak self] _ in
             self?.showNextCharacter()
         }
    }

    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.didTapBack()
    }

    @IBAction func didTapSkipButton(_ sender: Any) {
        self.currentIndex = self.currentText.count-1
        self.messageLabel.text = self.currentText
        self.showNextCharacter()
    }

    // MARK: - Helpers
    func loadChartView() {
        var entries: [PieChartDataEntry] = []
        for (key, value) in self.viewModel.typeExpenses() {
            entries.append(PieChartDataEntry(value: value/viewModel.totalExpense() * 100, label: key))
        }

        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = ChartColorTemplates.colorful()
        let data = PieChartData(dataSet: dataSet)

        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))

        // Đặt dữ liệu cho biểu đồ
        chartView.data = data
        chartView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
    }
}

// MARK: - ExpenseDetailsPresentable
extension ExpenseDetailsViewController: ExpenseDetailsPresentable {
    func bind(viewModel: ExpenseDetailsViewModel) {
        self.loadViewIfNeeded()
        self.viewModel = viewModel
        self.totalLabel.text = "Total expense: $" + viewModel.totalExpense().formatted()
        self.highestLabel.text = "Highest expense: $" + viewModel.highestExpense().formatted()
        self.currentText = self.viewModel.introMessage()
        self.loadChartView()
        self.showNextCharacter()
    }   
}

// MARK: - ChartViewDelegate
extension ExpenseDetailsViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let pieEntry = entry as? PieChartDataEntry, let type = pieEntry.label else {
            return
        }

        self.resetBubbleChat()
        self.currentIndex = 0
        self.currentText = self.viewModel.message(at: type)
        self.showNextCharacter()
    }
}
