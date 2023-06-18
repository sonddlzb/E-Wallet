//
//  ProfileInteractor+Account.swift
//  E-Wallet
//
//  Created by đào sơn on 09/06/2023.
//

import Foundation

extension ProfileInteractor: AccountListener {
    func routeToAddCard() {
        self.listener?.profileWantToRouteToAddCard()
    }

    func accountWantToDismiss() {
        self.router?.dismissAccount()
    }
}
