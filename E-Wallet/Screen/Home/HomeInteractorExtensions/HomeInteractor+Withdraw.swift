//
//  HomeInteractor+Withdraw.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import Foundation

extension HomeInteractor: WithdrawListener {
    func withDrawWantToDismiss() {
        self.router?.dismissWithdraw()
    }

    func withDrawWantToRouteToAddCard() {
        self.router?.routeToAddCard()
    }
}
