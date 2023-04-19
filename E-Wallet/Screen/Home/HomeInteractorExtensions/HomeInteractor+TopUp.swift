//
//  HomeInteractor+TopUp.swift
//  E-Wallet
//
//  Created by đào sơn on 17/04/2023.
//

import Foundation

extension HomeInteractor: TopUpListener {
    func topUpWantToDismiss() {
        self.router?.dismissTopUp()
    }

    func topUpWantToRouteToAddCard() {
        self.router?.routeToAddCard()
    }
}
