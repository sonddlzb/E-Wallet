//
//  HomeInteractor+Account.swift
//  E-Wallet
//
//  Created by đào sơn on 17/04/2023.
//

import Foundation

extension HomeInteractor: AccountListener {
    func routeToAddCard() {
        self.router?.routeToAddCard()
    }
}
