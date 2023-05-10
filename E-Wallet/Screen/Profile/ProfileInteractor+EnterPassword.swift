//
//  ProfileInteractor+EnterPassword.swift
//  E-Wallet
//
//  Created by đào sơn on 11/05/2023.
//

import Foundation
import SVProgressHUD

extension ProfileInteractor: EnterPasswordListener {
    func enterPasswordWantToDissmiss() {
        self.router?.dismissEnterPassword()
    }

    func enterPasswordWantToConfirmPassword(password: String) {
        self.router?.dismissEnterPassword()
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
            SVProgressHUD.dismiss()
            self.router?.routeToEnterPassword(isNewUser: true,
                                              isConfirmPassword: true,
                                              password: password)
        })
    }

    func enterPasswordDidConfirmPasswordSuccessfully(password: String) {
        self.router?.dismissEnterPassword()
        SVProgressHUD.show()
        UserDatabase.shared.updatePassword(newPassword: password) { error in
            SVProgressHUD.dismiss()
            DispatchQueue.main.async {
                if let error = error {
                    self.presenter.bindChangePasswordResult(isSuccess: false,
                                                            message: error.localizedDescription)
                } else {
                    self.presenter.bindChangePasswordResult(isSuccess: true,
                                                            message: "Your password was changed successfully!")
                }
            }
        }
    }

    func enterPasswordWantToAuthenticateOldUser(password: String) {
        SVProgressHUD.show()
        UserDatabase.shared.checkPassword(password: password) { isSuccess in
            SVProgressHUD.dismiss()
            if isSuccess {
                let userDefaults = UserDefaults.standard
                userDefaults.saveValidPasswordStatus()
            }

            DispatchQueue.main.async {
                self.router?.bindAuthenticationResultToEnterPassword(isSuccess: isSuccess)
            }
        }
    }

    func enterPasswordDidAuthenticateOldUserSuccess() {
        self.router?.dismissEnterPassword()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
            self.router?.routeToEnterPassword(isNewUser: true, isConfirmPassword: false, password: "")
        })
    }

    func enterPasswordWantToEndLoginSession() {
        self.router?.dismissEnterPassword()
        self.listener?.profileDidSignOut()
    }
}
