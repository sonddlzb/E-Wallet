//
//  RootInteractor+Introduction.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import Foundation

extension RootInteractor: IntroductionListener {
    func introductionWantToRouteSignIn() {
        self.router?.dismissIntroduction()
        self.router?.routeToSignIn()
    }
}
