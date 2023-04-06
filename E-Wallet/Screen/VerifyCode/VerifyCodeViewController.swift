//
//  VerifyCodeViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 06/04/2023.
//

import RIBs
import RxSwift
import UIKit

private struct Const {
    static let maxTime = 120
}

protocol VerifyCodePresentableListener: AnyObject {
    func verifyCodeWantToDismiss()
    func verifyPhoneNumber(verificationCode: String)
    func verifyCodeWantToResendCode(for phoneNumber: String)
}

final class VerifyCodeViewController: UIViewController, VerifyCodeViewControllable {
    // MARK: - Outlets
    @IBOutlet private weak var textField1: UITextField!
    @IBOutlet private weak var textField2: UITextField!
    @IBOutlet private weak var textField3: UITextField!
    @IBOutlet private weak var textField4: UITextField!
    @IBOutlet private weak var textField5: UITextField!
    @IBOutlet private weak var textField6: UITextField!
    @IBOutlet private weak var labelPhoneNumber: UILabel!
    @IBOutlet private weak var labelCountingTime: UILabel!
    @IBOutlet private weak var resendLabel: UILabel!
    @IBOutlet private weak var resendButton: TapableView!

    // MARK: - Variables
    weak var listener: VerifyCodePresentableListener?
    private var phoneNumber: String
    private var textField1IsEditing = false
    private var textField2IsEditing = false
    private var textField3IsEditing = false
    private var textField4IsEditing = false
    private var textField5IsEditing = false
    private var textField6IsEditing = false

    private var timeCounting = Const.maxTime

    // MARK: - Lifecycle
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    private func setUpView() {
        textField1.delegate = self
        textField2.delegate = self
        textField3.delegate = self
        textField4.delegate = self
        textField5.delegate = self
        textField6.delegate = self
        textField1.becomeFirstResponder()
        self.labelPhoneNumber.text = phoneNumber

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            if var time = self?.timeCounting, time > 0 {
                time -= 1
                self?.labelCountingTime.text = String(time)
                self?.timeCounting = time
                self?.resendButton.isUserInteractionEnabled = false
                self?.resendLabel.textColor = .lightGray
            } else {
                self?.resendButton.isUserInteractionEnabled = true
                self?.resendLabel.textColor = .crayola
            }
        }
    }

    // MARK: - Actions
    @IBAction func btnPopScreenDidTap(_ sender: Any) {
        self.listener?.verifyCodeWantToDismiss()
    }

    @IBAction func btnVerifyDidTap(_ sender: Any) {
        let digit1 = self.textField1.text ?? ""
        let digit2 = self.textField2.text ?? ""
        let digit3 = self.textField3.text ?? ""
        let digit4 = self.textField4.text ?? ""
        let digit5 = self.textField5.text ?? ""
        let digit6 = self.textField6.text ?? ""
        let verificationCode = digit1 + digit2 + digit3 + digit4 + digit5 + digit6
        self.listener?.verifyPhoneNumber(verificationCode: verificationCode)
    }

    @IBAction func didTapResendButton(_ sender: Any) {
        guard self.timeCounting == 0 else {
            return
        }

        self.listener?.verifyCodeWantToResendCode(for: self.phoneNumber)
        self.timeCounting = Const.maxTime
    }
}

// MARK: - UITextFieldDelegate
extension VerifyCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if self.textField1.text?.count == 1 {
            self.textField2.becomeFirstResponder()
            textField1IsEditing = true
        }

        if self.textField2.text?.count == 1 {
            self.textField3.becomeFirstResponder()
            self.textField2IsEditing = true
        }

        if self.textField3.text?.count == 1 {
            textField4.becomeFirstResponder()
            textField3IsEditing = true
        }

        if self.textField4.text?.count == 1 {
            textField5.becomeFirstResponder()
            textField4IsEditing = true
        }

        if self.textField5.text?.count == 1 {
            textField6.becomeFirstResponder()
            textField5IsEditing = true
        }

        if self.textField6.text?.count == 1 {
            textField6IsEditing = true
            self.view.endEditing(true)
        }

        if textField6IsEditing == true && textField6.text?.count == 0 {
            textField5.becomeFirstResponder()
            textField6IsEditing = false
        }

        if textField5IsEditing == true && textField5.text?.count == 0 {
            textField4.becomeFirstResponder()
            textField5IsEditing = false
        }

        if textField4IsEditing == true && textField4.text?.count == 0 {
            textField3.becomeFirstResponder()
            textField4IsEditing = false
        }

        if textField3IsEditing == true && textField3.text?.count == 0 {
            textField2.becomeFirstResponder()
            textField3IsEditing = false
        }

        if textField2IsEditing == true && textField2.text?.count == 0 {
            textField1.becomeFirstResponder()
            textField2IsEditing = false
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.borderColor = .crayola
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.borderColor = .lightGray
        return true
    }
}

extension VerifyCodeViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - VerifyCodePresentable
extension VerifyCodeViewController: VerifyCodePresentable {
    func showFailedDialog(title: String, message: String) {
        FailedDialog.show(title: title, message: message)
    }
}
