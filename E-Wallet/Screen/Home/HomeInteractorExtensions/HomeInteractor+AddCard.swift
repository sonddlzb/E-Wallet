//
//  HomeInteractor+AddCard.swift
//  E-Wallet
//
//  Created by đào sơn on 17/04/2023.
//

import Foundation

extension HomeInteractor: AddCardListener {
    func addCardWantToDismiss() {
        self.router?.dismissAddCard(animated: true)
    }

    func addCardWantToReloadData() {
        self.router?.reloadCardData()
        self.router?.dismissAddCard(animated: true)
    }
}
