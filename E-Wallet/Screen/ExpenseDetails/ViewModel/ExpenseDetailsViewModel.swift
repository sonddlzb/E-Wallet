//
//  ExpenseDetailsViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 24/05/2023.
//

import Foundation
import FirebaseAuth

struct ExpenseDetailsViewModel {
    var listTransactions: [Transaction]
    var startDate = Date()

    static func makeEmpty() -> ExpenseDetailsViewModel {
        return ExpenseDetailsViewModel(listTransactions: [])
    }

    func listTransactionsType() -> [String] {
        guard let userId = Auth.auth().currentUser?.uid else {
            return []
        }

        var types: Set<String> = []
        self.listTransactions.forEach {
            if !($0.type == .topUp || ($0.type == .transfer && $0.receiverId == userId)) {
                types.insert($0.type.rawValue)
            }
        }

        return Array(types)
    }

    func typeExpenses() -> [String: Double] {
        var typeExpenses: [String: Double] = [:]
        for transactionType in self.listTransactionsType() {
            if typeExpenses[transactionType] == nil {
                typeExpenses[transactionType] = 0.0
            }

            typeExpenses[transactionType]! += self.listTransactions.filter {
                $0.type.rawValue == transactionType
            }.reduce(0.0, { result, transaction in
                return result + transaction.amount
            })
        }

        return typeExpenses
    }

    func totalExpense() -> Double {
        return self.listTransactions.reduce(0) { result, transaction in
            return result + transaction.amount
        }
    }

    func highestExpense() -> Double {
        return self.listTransactions.max {
            $0.amount < $1.amount
        }?.amount ?? 0.0
    }

    func message(at type: String) -> String {
        guard self.totalExpense() != 0.0 else {
            return "Sorry, you haven't made any payments in \(self.startDate.monthName())."
        }

        let amount = self.typeExpenses()[type] ?? 0
        let rate = (amount/totalExpense() * 100).formatted()
        return "In \(self.startDate.monthName()), you paid totally $\(amount) for \(type) service, which rated \(rate)% in your total expense."
    }

    func introMessage() -> String {
        guard self.totalExpense() != 0.0 else {
            return "Sorry, you haven't made any payments in \(self.startDate.monthName())."
        }

        return "Welcome you to expense management feature in E-Wallet!"
    }
}
