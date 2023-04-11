//
//  RootInteractor+Splash.swift
//  E-Wallet
//
//  Created by đào sơn on 05/04/2023.
//

import Foundation
import FirebaseAuth

extension RootInteractor: SplashListener {
    func splashWantToDismiss() {
        if self.userDefaults.launchCount() == 1 {
            self.router?.routeToIntroduction()
        } else {
            if Auth.auth().currentUser == nil {
                self.router?.routeToSignIn()
            } else {
                self.router?.routeToHome()
            }
        }

        self.router?.dismissSplash()
    }
}
