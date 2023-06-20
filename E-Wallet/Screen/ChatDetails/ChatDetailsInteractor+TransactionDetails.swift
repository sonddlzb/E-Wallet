//
//  ChatDetailsInteractor+TransactionDetails.swift
//  E-Wallet
//
//  Created by đào sơn on 20/06/2023.
//

import Foundation

extension ChatDetailsInteractor: TransactionDetailsListener {
    func transactionDetailsWantToDismiss() {
        self.router?.dismissHistory()
    }
}
