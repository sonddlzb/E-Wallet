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
        SVProgressHUD.show()
        switch self.viewModel.paymentType() {
        case .transfer:
            AccountDatabase.shared.transfer(selectedCard: self.viewModel.selectedCard, amount: self.viewModel.amount(), receiverPhoneNumber: self.viewModel.phoneNumber(), completion: { [weak self] error, transaction in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    if let error = error {
                        print("transfer failed! \(error.localizedDescription)")
                        self?.presenter.bindPaymentResult(isSuccess: false, message: error.localizedDescription)
                    } else {
                        print("transfer successfully")
                        self?.presenter.bindPaymentResult(isSuccess: true, message: "Your money has been transfered successfully")
                        if let transaction = transaction {
                            self?.router?.routeToReceipt(transaction: transaction)
                        }
                    }
                }
            })
        case .topUp:
            CardDatabase.shared.getCardById(self.viewModel.cardId()) { card in
                guard let card = card else {
                    return
                }

                STPPaymentHelper.shared.handlePayment(card: card, price: self.viewModel.amount(), paymentType: .topUp, completion: {[weak self] error in
                    if let error = error {
                        SVProgressHUD.dismiss()
                        DispatchQueue.main.async {
                            self?.presenter.bindPaymentResult(isSuccess: false, message: error.localizedDescription)
                        }
                    } else {
                        AccountDatabase.shared.topUp(amount: self?.viewModel.amount() ?? 0.0) { error, transaction in
                            SVProgressHUD.dismiss()
                            if let error = error {
                                self?.presenter.bindPaymentResult(isSuccess: false, message: error.localizedDescription)
                            } else {
                                DispatchQueue.main.async {
                                    self?.presenter.bindPaymentResult(isSuccess: true, message: "Your top-up payment was handled successfully")
                                    if let transaction = transaction {
                                        self?.router?.routeToReceipt(transaction: transaction)
                                    }
                                }
                            }
                        }
                    }
                })
            }

        case .withdraw:
            CardDatabase.shared.getCardById(self.viewModel.cardId()) { card in
                guard let card = card else {
                    return
                }

                STPPaymentHelper.shared.handlePayment(card: card, price: self.viewModel.amount(), paymentType: .withdraw, completion: {[weak self] error in
                    if let error = error {
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            self?.presenter.bindPaymentResult(isSuccess: false, message: error.localizedDescription)
                        }
                    } else {
                        AccountDatabase.shared.withdraw(amount: self?.viewModel.amount() ?? 0.0) { error, transaction in
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                                if let error = error {
                                    self?.presenter.bindPaymentResult(isSuccess: false, message: error.localizedDescription)
                                } else {
                                    self?.presenter.bindPaymentResult(isSuccess: true, message: "Your withdraw payment was handled successfully")
                                    if let transaction = transaction {
                                        self?.router?.routeToReceipt(transaction: transaction)
                                    }
                                }
                            }
                        }
                    }
                })
            }

        default: print("not handle")
        }
    }
}
