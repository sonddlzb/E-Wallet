//
//  RootInteractor+SignIn.swift
//  E-Wallet
//
//  Created by đào sơn on 06/04/2023.
//

import Foundation

extension RootInteractor: SignInListener {
    func routeToHome() {
        self.router?.routeToHome()
    }
}
