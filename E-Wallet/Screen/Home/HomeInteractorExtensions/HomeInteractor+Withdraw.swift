//
//  HomeInteractor+Withdraw.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import Foundation

extension HomeInteractor: WithdrawListener {
    func withDrawWantToDismiss() {
        self.router?.dismissWithdraw(animated: true)
    }

    func withDrawWantToRouteToAddCard() {
        self.router?.routeToAddCard()
    }

    func withdrawWantToRouteToTransactionConfirm(confirmData: [String: String]) {
        self.router?.routeToTransactionConfirm(confirmData: confirmData, isShowPaymentMethodView: false)
    }
}
