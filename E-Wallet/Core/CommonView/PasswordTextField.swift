//
//  PasswordTextField.swift
//  Zip
//
//  Created by Linh Nguyen Duc on 23/06/2022.
//

import UIKit

class PasswordTextField: SolarTextField {
    // MARK: - UI

    // MARK: - Config
    override func commonInit() {
        super.commonInit()
        self.isSecureText = true
    }

    override func configTextField() {
        super.configTextField()
    }

    // MARK: - Override
    override func didSetSecureText() {
        super.didSetSecureText()
        let image = UIImage(named: self.isSecureText ? "ic_password_hide" : "ic_password_show")
        self.rightButton.setImage(image, for: .normal)
    }

    override func didChangePlaceHolder() {
        self.textField.attributedPlaceholder = self.attributedPlaceholder(for: self.textField.placeholder ?? "")
    }

    override func handleRightButtonDidTap() {
        self.isSecureText = !self.isSecureText
    }

    // MARK: - Public method
    func displayIncorrectPassword() {
        self.textField.text = ""
        self.textField.placeholder = "Incorrect password"
        self.textField.attributedPlaceholder = NSAttributedString(string: self.textField.placeholder!, attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .medium),
            .foregroundColor: UIColor(rgb: 0xFF6C39)
        ])
    }

    // MARK: - Helper
    private func attributedPlaceholder(for text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .medium),
            .foregroundColor: UIColor(rgb: 0xCACACA)
        ])
    }
}

extension PasswordTextField {
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        self.textField.placeholder = self.placeholder
        self.textField.attributedPlaceholder = self.attributedPlaceholder(for: self.placeholder ?? "")
    }
}
