//
//  TransactionConfirmInteractor+EnterPassword.swift
//  E-Wallet
//
//  Created by đào sơn on 20/04/2023.
//

import Foundation
import SVProgressHUD

extension TransactionConfirmInteractor: EnterPasswordListener {
    func enterPasswordWantToDissmiss() {
        self.router?.dismissPassword()
    }

    func enterPasswordWantToConfirmPassword(password: String) {

    }

    func enterPasswordDidConfirmPasswordSuccessfully(password: String) {

    }

    func enterPasswordWantToAuthenticateOldUser(password: String) {
        SVProgressHUD.show()
        UserDatabase.shared.checkPassword(password: password) { isSuccess in
            SVProgressHUD.dismiss()
            DispatchQueue.main.async {
                self.router?.bindAuthenticationResultToEnterPassword(isSuccess: isSuccess)
            }
        }
    }

    func enterPasswordDidAuthenticateOldUserSuccess() {
        self.router?.dismissPassword()
        switch self.viewModel.paymentType() {
        case .transfer:
            AccountDatabase.shared.transfer(amount: self.viewModel.amount(), receiverPhoneNumber: self.viewModel.phoneNumber(), completion: { error, transaction in
                if let error = error {
                    print("transfer failed! \(error.localizedDescription)")
                    self.presenter.bindPaymentResult(isSuccess: false, message: error.localizedDescription)
                } else {
                    print("transfer successfully")
                    self.presenter.bindPaymentResult(isSuccess: true, message: "Your money has been transfered successfully")
                    if let transaction = transaction {
                        self.router?.routeToReceipt(transaction: transaction)
                    }
                }
            })
        default: print("not handle")
        }
    }
}
