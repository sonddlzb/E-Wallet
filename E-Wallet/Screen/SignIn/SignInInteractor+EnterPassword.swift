//
//  SignInInteractor+EnterPassword.swift
//  E-Wallet
//
//  Created by đào sơn on 07/04/2023.
//

import Foundation
import SVProgressHUD

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
        self.password = password
        self.router?.dismissEnterPassword()
        print("Create new account successfully with password \(password)")
        self.router?.routeToFillProfile()
    }

    func enterPasswordWantToAuthenticateOldUser(password: String) {
        SVProgressHUD.show()
        UserDatabase.shared.checkPassword(password: password) { isSuccess in
            SVProgressHUD.dismiss()
            DispatchQueue.main.async {
                self.router?.bindSignInResultToEnterPassword(isSuccess: isSuccess)
            }
        }
    }

    func enterPasswordWantToRouteToHome() {
        self.listener?.routeToHome()
    }
}
