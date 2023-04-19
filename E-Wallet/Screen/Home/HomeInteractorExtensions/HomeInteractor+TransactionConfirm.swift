//
//  HomeInteractor+TransactionConfirm.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import Foundation

extension HomeInteractor: TransactionConfirmListener {
    func transactionConfirmWantToDismiss() {
        self.router?.dismissTransactionConfirm()
    }

    func selectCardWantToRouteToAddNewCard() {
        self.router?.routeToAddCard()
    }
}
