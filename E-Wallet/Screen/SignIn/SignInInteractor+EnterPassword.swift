//
//  SignInInteractor+EnterPassword.swift
//  E-Wallet
//
//  Created by đào sơn on 07/04/2023.
//

import Foundation

extension SignInInteractor: EnterPasswordListener {
    func enterPasswordWantToDissmiss() {
        self.router?.dismissEnterPassword()
    }

    func enterPasswordWantToConfirmPassword(password: String) {
        self.router?.dismissEnterPassword()
        self.router?.routeToEnterPassword(isNewUser: true,
                                          isConfirmPassword: true,
                                          password: password)
    }

    func enterPasswordDidConfirmPasswordSuccessfully(password: String) {
        self.router?.dismissEnterPassword()
        print("Create new account successfully with password \(password)")
    }

    func enterPasswordWantToAuthenticateOldUser(password: String) {
        // check login password here
        self.router?.bindSignInResultToEnterPassword(isSuccess: false)
    }
}
