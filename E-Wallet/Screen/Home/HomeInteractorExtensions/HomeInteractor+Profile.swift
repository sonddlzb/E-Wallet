//
//  HomeInteractor+Profile.swift
//  E-Wallet
//
//  Created by đào sơn on 12/04/2023.
//

import Foundation

extension HomeInteractor: ProfileListener {
    func profileDidSignOut() {
        self.listener?.routeToSignIn()
    }

    func profileWantToReloadUserInfor() {
        self.fetchUserInfor()
    }
}
