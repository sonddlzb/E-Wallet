//
//  HistoryViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 25/04/2023.
//

import Foundation

struct HistoryViewModel: Equatable {
    static func == (lhs: HistoryViewModel, rhs: HistoryViewModel) -> Bool {
        return lhs.listTransaction.map{ $0.id} == rhs.listTransaction.map {$0.id}
    }

    var listTransaction: [Transaction]

    static func makeEmpty() -> HistoryViewModel {
        return HistoryViewModel(listTransaction: [])
    }

    func item(at index: Int) -> HistoryItemViewModel {
        return HistoryItemViewModel(transaction: self.listTransaction[index])
    }

    func numberOfTransactions() -> Int {
        return self.listTransaction.count
    }

    func filteredModal(by key: String, completion: @escaping (_ viewModel: HistoryViewModel) -> Void) {
        var listFilterTransactions: [Transaction] = []
        for (index, transaction) in self.listTransaction.enumerated() {
            if HistoryItemViewModel(transaction: transaction).description().lowercased().contains(key) {
                listFilterTransactions.append(transaction)
            }

            if index == self.listTransaction.count-1 {
                completion(HistoryViewModel(listTransaction: listFilterTransactions))
            }
        }
    }

    func transaction(at index: Int) -> Transaction {
        return self.listTransaction[index]
    }
}
