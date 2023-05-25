//
//  ExpenseViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 19/05/2023.
//

private struct Const {
    static let monthsNumber = 5
}

import Foundation
import FirebaseAuth

struct ExpenseViewModel {
    var listTransactions: [Transaction]

    static func makeEmpty() -> ExpenseViewModel {
        return ExpenseViewModel(listTransactions: [])
    }

    func listExpenseTransactions() -> [Transaction] {
        guard let userId = Auth.auth().currentUser?.uid else {
            return []
        }
        
        return self.listTransactions.filter {
            !(($0.type == .transfer && $0.receiverId == userId) || $0.type == .topUp)
        }
    }

    func listIncomeTransactions() -> [Transaction] {
        guard let userId = Auth.auth().currentUser?.uid else {
            return []
        }

        return self.listTransactions.filter {
            ($0.type == .transfer && $0.receiverId == userId) || $0.type == .topUp
        }
    }

    func expenseItem(at index: Int) -> HistoryItemViewModel {
        return HistoryItemViewModel(transaction: self.listExpenseTransactions()[index])
    }

    func incomeItem(at index: Int) -> HistoryItemViewModel {
        return HistoryItemViewModel(transaction: self.listIncomeTransactions()[index])
    }

    func numberOfExpenseTransactions() -> Int {
        return self.listExpenseTransactions().count
    }

    func numberOfIncomeTransactions() -> Int {
        return self.listIncomeTransactions().count
    }

    func listMonths() -> [String] {
        var listMonths: [String] = []
        for index in 0...Const.monthsNumber-1 {
            if let month = Date().getMonth(by: -index)?.monthName() {
                listMonths.append(month)
            }
        }

        return listMonths.reversed()
    }

    func fetchListMonthsTotalMoney(completion: @escaping (_ listData: [Double]) -> Void) {
        var listData: [String: Double] = [:]
        for index in 0...Const.monthsNumber-1 {
            let filterModel = FilterModel(month: self.listMonths()[index], service: "All", startAmount: 0, endAmount: 2000, status: "completed")
            TransactionDatabase.shared.filterTransaction(filterModel: filterModel) { listTransactions in
                listData[self.listMonths()[index]] = listTransactions.reduce(0) { result, transaction in
                    return result + transaction.amount
                }

                if listData.count == Const.monthsNumber {
                    DispatchQueue.main.async {
                        var listSortedData: [Double] = []
                        for index in 0...Const.monthsNumber-1 {
                            listSortedData.append(listData[self.listMonths()[index]] ?? 0)
                        }

                        completion(listSortedData)
                    }
                }
            }
        }
    }
}
