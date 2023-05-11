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
            UserDatabase.shared.checkValidUser { [weak self] isValidUser in
                if isValidUser {
                    if Auth.auth().currentUser == nil || !(self?.userDefaults.isValidatePassword() ?? true) {
                        self?.router?.routeToSignIn()
                    } else {
                        self?.router?.routeToHome()
                    }
                } else {
                    Auth.auth().currentUser?.delete()
                    self?.router?.routeToSignIn()
                }
            }
        }

        self.router?.dismissSplash()
    }
}
