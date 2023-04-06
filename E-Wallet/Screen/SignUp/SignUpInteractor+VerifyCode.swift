//
//  SignUpInteractor+VerifyCode.swift
//  E-Wallet
//
//  Created by đào sơn on 06/04/2023.
//

import Foundation

extension SignUpInteractor: VerifyCodeListener {
    func verifyCodeSuccessfully(isNewUser: Bool) {
        // handle sign up success
    }

    func verifyCodeWantToDismiss() {
        self.router?.dismissVerifyCode()
    }
}
