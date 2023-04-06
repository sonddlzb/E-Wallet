//
//  RootInteractor+SignUp.swift
//  E-Wallet
//
//  Created by đào sơn on 06/04/2023.
//

import Foundation

extension RootInteractor: SignUpListener {
    func signUpWantToRouteToSignIn() {
        self.router?.dismissSignUp()
        self.router?.routeToSignIn()
    }
}
