//
//  TransferViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 13/04/2023.
//

import RIBs
import RxSwift
import UIKit
import Contacts
import ContactsUI

protocol TransferPresentableListener: AnyObject {
    func transferWantToDismiss()
    func openContacts()
    func getNameBy(phoneNumber: String, completion: @escaping (_ name: String) -> Void)
    func routeToTransactionConfirm(phoneNumber: String, name: String, amount: Double, message: String)
    func didSelectQR()
}

final class TransferViewController: UIViewController, TransferViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var moneyTextField: UITextField!
    @IBOutlet private weak var messageTextView: UITextView!
    @IBOutlet private weak var phoneNumberTextField: SolarTextField!
    @IBOutlet private weak var phoneNumberHeighConstraint: NSLayoutConstraint!
    @IBOutlet private weak var transferButton: TapableView!
    @IBOutlet private weak var transferLabel: UILabel!

    @IBOutlet weak var transferButtonBottomConstraint: NSLayoutConstraint!
    // MARK: - Variables
    weak var listener: TransferPresentableListener?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.configPhoneNumberTextField()

        self.messageTextView.delegate = self

        self.moneyTextField.keyboardType = .decimalPad
        self.moneyTextField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func configPhoneNumberTextField() {
        phoneNumberTextField.placeholder = "Type your receiver phone number"
        phoneNumberTextField.isHighlightedWhenEditting = true
        phoneNumberTextField.backgroundColor = .lotion
        phoneNumberTextField.borderColor = .crayola
        phoneNumberTextField.textField.paddingLeft = 10
        phoneNumberTextField.cornerRadius = 12
        phoneNumberTextField.isRightButtonEnable = true
        phoneNumberTextField.setRightImage(image: UIImage(named: "ic_contact"))
        phoneNumberTextField.paddingRight = 10.0
        phoneNumberTextField.keyboardType = .decimalPad
        phoneNumberTextField.delegate = self
        phoneNumberTextField.textField.contentVerticalAlignment = .top
        phoneNumberTextField.textField.paddingTop = 10.0
    }

    // MARK: - Actions
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.listener?.transferWantToDismiss()
    }

    @IBAction func didTapQRButton(_ sender: Any) {
        self.listener?.didSelectQR()
    }

    @IBAction func transferButtonDidTap(_ sender: Any) {
        guard let name = self.nameLabel.text, !name.isEmpty, self.phoneNumberTextField.text.isPhoneNumberValid() else {
            FailedDialog.show(title: "Oh no!", message: "You must enter a valid user")
            return
        }

        if let amount = self.moneyTextField.text?.convertMoneyToNumber() {
            self.listener?.routeToTransactionConfirm(phoneNumber: phoneNumberTextField.text, name: name, amount: amount, message: self.messageTextView.text)
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.15) {
                self.transferButtonBottomConstraint.constant = keyboardSize.height + 10.0
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.15) {
            self.transferButtonBottomConstraint.constant = 20.0
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - SolarTextFieldDelegate
extension TransferViewController: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        return true
    }

    func solarTextFieldDidTapRightButton(_ textField: SolarTextField) {
        self.listener?.openContacts()
    }

    func solarTextFieldShouldBeginEditting(_ textField: SolarTextField) -> Bool {
        self.phoneNumberHeighConstraint.constant = 40.0
        self.nameLabel.text = ""
        return true
    }

    func solarTextFieldDidEndEditting(_ textField: SolarTextField) {
        self.listener?.getNameBy(phoneNumber: self.phoneNumberTextField.text.formatPhoneNumber(), completion: { name in
            if !name.isEmpty {
                self.nameLabel.text = name
                self.phoneNumberHeighConstraint.constant = 55.0
            }
        })
    }
}

// MARK: - TransferPresentable
extension TransferViewController: TransferPresentable {
    func openContactsVC() {
        DispatchQueue.main.async {
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            contactPicker.displayedPropertyKeys =
                [CNContactPhoneNumbersKey]
            self.present(contactPicker, animated: true, completion: nil)
        }
    }

    func bind(phoneNumber: String) {
        self.loadViewIfNeeded()
        self.phoneNumberTextField.text = phoneNumber.formatPhoneNumber()
        self.listener?.getNameBy(phoneNumber: phoneNumber.formatPhoneNumber(), completion: { name in
            if !name.isEmpty {
                self.nameLabel.text = name
                self.phoneNumberHeighConstraint.constant = 55.0
            }
        })
    }
}

// MARK: - CNContactPickerDelegate
extension TransferViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contactProperty: CNContactProperty) {
        if let phoneNumber = contactProperty.value as? CNPhoneNumber {
            self.phoneNumberTextField.text = phoneNumber.stringValue.formatPhoneNumber()
            self.listener?.getNameBy(phoneNumber: self.phoneNumberTextField.text, completion: { name in
                if !name.isEmpty {
                    self.nameLabel.text = name
                    self.phoneNumberHeighConstraint.constant = 58.0
                    self.phoneNumberTextField.resignFirstResponder()
                } else {
                    if self.nameLabel.text?.isEmpty == false {
                        self.nameLabel.text = ""
                        self.phoneNumberHeighConstraint.constant = 55.0
                    }
                }
            })
        }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel pick contact")
    }
}

extension TransferViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - UITextViewDelegate
extension TransferViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Your message" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Your message"
            textView.textColor = UIColor.lightGray
        }
    }
}

// MARK: - UITextFieldDelegate
extension TransferViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the text after adding the replacement string.
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""

        // Remove all non-digit characters from the updated text.
        let filteredText = updatedText.filter("0123456789.".contains)
        if filteredText.isEmpty {
            textField.textColor = .lightGray
            self.transferLabel.backgroundColor = .lightGray
            self.transferButton.isUserInteractionEnabled = false
        } else {
            textField.textColor = .black
            self.transferLabel.backgroundColor = .crayola
            self.transferButton.isUserInteractionEnabled = true
        }

        if string != "." && !string.isEmpty {
            textField.text = filteredText.formatMoney()
        } else {
            textField.text = filteredText
        }

        return false
    }
}
