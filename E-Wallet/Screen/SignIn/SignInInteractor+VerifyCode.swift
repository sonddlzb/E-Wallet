//
//  SignInInteractor+VerifyCode.swift
//  E-Wallet
//
//  Created by đào sơn on 06/04/2023.
//

import Foundation

extension SignInInteractor: VerifyCodeListener {
    func verifyCodeWantToDismiss() {
        self.router?.dismissVerifyCode()
    }

    func verifyCodeSuccessfully(isNewUser: Bool) {
        // handle sign in success
    }
}
