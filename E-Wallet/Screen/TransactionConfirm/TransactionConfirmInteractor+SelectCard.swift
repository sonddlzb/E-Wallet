//
//  TransactionConfirmInteractor+SelectCard.swift
//  E-Wallet
//
//  Created by đào sơn on 19/04/2023.
//

import Foundation

extension TransactionConfirmInteractor: SelectCardListener {
    func selectCardWantToDismiss() {
        self.router?.dismissSelectCard()
    }

    func selectCardDidSelectAt(indexPath: IndexPath) {
        self.presenter.bindCardSelectedResult(at: indexPath)
    }

    func selectCardWantToRouteToAddNewCard() {
        self.router?.dismissSelectCard()
        self.listener?.selectCardWantToRouteToAddNewCard()
    }
}
