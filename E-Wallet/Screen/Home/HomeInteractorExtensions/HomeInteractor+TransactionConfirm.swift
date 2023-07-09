//
//  HomeInteractor+TransactionConfirm.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import Foundation

extension HomeInteractor: TransactionConfirmListener {
    func transactionConfirmWantToDismiss() {
        self.router?.dismissTransactionConfirm(animated: true)
    }

    func selectCardWantToRouteToAddNewCard() {
        self.router?.routeToAddCard()
    }

    func receiptWantToRouteToHome() {
        self.router?.routeBackToHome()
    }

    func receiptWantToSeeDetails(transaction: Transaction) {
        self.presenter.selectHistoryTab()
        self.router?.receiptWantToSeeDetails(transaction: transaction)
    }

    func transactionConfirmWantToEndLoginSession() {
        UserDefaults.standard.removeValidPasswordStatus()
        self.listener?.routeToSignIn()
    }

    func receiptWantToRouteToChatDetails(with user: User) {
        self.presenter.selectChatTab()
        self.router?.receiptWantToRouteToChatDetail(with: user)
    }
}
