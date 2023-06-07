//
//  NotificationsInteractor+TransactionDetails.swift
//  E-Wallet
//
//  Created by đào sơn on 06/06/2023.
//

import Foundation

extension NotificationsInteractor: TransactionDetailsListener {
    func transactionDetailsWantToDismiss() {
        self.router?.dismissHistory()
    }
}
