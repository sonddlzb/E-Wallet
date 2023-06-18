//
//  HomeInteractor+Profile.swift
//  E-Wallet
//
//  Created by đào sơn on 12/04/2023.
//

import Foundation

extension HomeInteractor: ProfileListener {
    func profileDidSignOut() {
        UserDefaults.standard.removeValidPasswordStatus()
        self.listener?.routeToSignIn()
    }

    func profileWantToReloadUserInfor() {
        self.fetchUserInfor()
    }

    func profileWantToRouteToGift() {
        self.router?.routeToTab(homeTab: .gift)
    }

    func profileWantToRouteToAddCard() {
        self.router?.routeToAddCard()
    }
}
