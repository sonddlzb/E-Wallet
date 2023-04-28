//
//  HistoryInteractor+TransactionDetails.swift
//  E-Wallet
//
//  Created by đào sơn on 28/04/2023.
//

import Foundation

extension HistoryInteractor: TransactionDetailsListener {
    func transactionDetailsWantToDismiss() {
        self.router?.dismissTransactionDetails()
    }
}
