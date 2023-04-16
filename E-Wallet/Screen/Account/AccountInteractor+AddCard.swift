//
//  AccountInteractor+AddCard.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import Foundation

extension AccountInteractor: AddCardListener {
    func addCardWantToDismiss() {
        self.router?.dismissAddCard()
    }

    func addCardWantToReloadData() {
        self.fetchAccounts()
        self.router?.dismissAddCard()
    }
}
