//
//  SignInInteractor+VerifyCode.swift
//  E-Wallet
//
//  Created by đào sơn on 06/04/2023.
//

import Foundation
import SVProgressHUD

extension SignInInteractor: VerifyCodeListener {
    func verifyCodeWantToDismiss() {
        self.router?.dismissVerifyCode()
    }

    func verifyCodeSuccessfully(isNewUser: Bool) {
        self.router?.dismissVerifyCode()
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
            SVProgressHUD.dismiss()
            self.router?.routeToEnterPassword(isNewUser: isNewUser, isConfirmPassword: false, password: "")
        })
    }
}
