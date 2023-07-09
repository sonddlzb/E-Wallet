//
//  TransactionConfirm+Receipt.swift
//  E-Wallet
//
//  Created by đào sơn on 23/04/2023.
//

import Foundation

extension TransactionConfirmInteractor: ReceiptListener {
    func receiptWantToRouteToHome() {
        self.router?.dismissReceipt(animated: false)
        self.listener?.receiptWantToRouteToHome()
    }

    func receiptWantToSeeDetails(transaction: Transaction) {
        self.router?.dismissReceipt(animated: false)
        self.listener?.receiptWantToRouteToHome()
        self.listener?.receiptWantToSeeDetails(transaction: transaction)
    }

    func receiptWantToGoToConversation(with user: User) {
        self.router?.dismissReceipt(animated: false)
        self.listener?.receiptWantToRouteToChatDetails(with: user)
    }
}
