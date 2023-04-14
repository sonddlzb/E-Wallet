//
//  AddCardViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import RIBs
import RxSwift
import UIKit
import CreditCardForm
import Stripe

protocol AddCardPresentableListener: AnyObject {
    func didTapAddNewCardButton(cardParam: STPCardParams)
    func addCardWantToDismiss()
    func addCardWantToReloadData()
}

final class AddCardViewController: UIViewController, AddCardViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var paymentTextField: STPPaymentCardTextField!
    @IBOutlet private weak var creditCardForm: CreditCardFormView!

    // MARK: - Variables
    weak var listener: AddCardPresentableListener?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    private func config() {
        self.paymentTextField.layer.borderWidth = 0

        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0,
                              y: paymentTextField.frame.size.height - width,
                              width: paymentTextField.frame.size.width,
                              height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        paymentTextField.delegate = self
    }

    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        self.listener?.addCardWantToDismiss()
    }

    @IBAction func didTapAddNewCardButton(_ sender: Any) {
        let cardParam = STPCardParams()
        cardParam.number = self.paymentTextField.cardNumber
        cardParam.expMonth = UInt(self.paymentTextField.expirationMonth)
        cardParam.expYear = UInt(self.paymentTextField.expirationYear)
        cardParam.cvc = self.paymentTextField.cvc
        self.listener?.didTapAddNewCardButton(cardParam: cardParam)
    }
}

// MARK: - STPPaymentCardTextFieldDelegate
extension AddCardViewController: STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardForm.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber,
                                                     expirationYear: UInt(textField.expirationYear),
                                                     expirationMonth: UInt(textField.expirationMonth),
                                                     cvc: textField.cvc)
    }

    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
    creditCardForm.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }

    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
    creditCardForm.paymentCardTextFieldDidBeginEditingCVC()
    }

    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
    creditCardForm.paymentCardTextFieldDidEndEditingCVC()
    }
}

// MARK: - AddCardPresentable
extension AddCardViewController: AddCardPresentable {
    func bindAddCardResult(isSuccess: Bool) {
        if !isSuccess {
            FailedDialog.show(title: "Add card error", message: "Something went wrong. Try again!")
        } else {
            let notificationView = NotificationDialogView.loadView()
            notificationView.delegate = self
            notificationView.show(in: self.view, title: "Add new card successfully!", message: "Your card was added for your payment.")
        }
    }
}

// MARK: - NotificationDialogViewDelegate
extension AddCardViewController: NotificationDialogViewDelegate {
    func notificationDialogViewDidTapOk(_ notificationDialogView: NotificationDialogView) {
        self.listener?.addCardWantToReloadData()
        self.listener?.addCardWantToDismiss()
    }
}
