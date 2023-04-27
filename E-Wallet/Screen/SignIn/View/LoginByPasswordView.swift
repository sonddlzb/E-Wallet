//
//  LoginByPasswordView.swift
//  E-Wallet
//
//  Created by đào sơn on 03/04/2023.
//

import UIKit

private struct Const {
    static let leftPadding = 20.0
    static let rightPadding = -50.0
}

protocol LoginByPasswordViewDelegate: AnyObject {
    func loginByPasswordViewDidTapConfirm(_ loginByPasswordView: LoginByPasswordView, phoneNumber: String)
}

class LoginByPasswordView: UIView {
    // MARK: - Outlets
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    private lazy var confirmButton: TapableView = {
        let confirmButton = TapableView()
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.cornerRadius = 20
        confirmButton.isUserInteractionEnabled = false
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton(_:)), for: .touchUpInside)
        return confirmButton
    }()

    private lazy var phoneNumberTextField: SolarTextField = {
        let phoneNumberTextField = SolarTextField()
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberTextField.placeholder = "Phone Number"
        phoneNumberTextField.isHighlightedWhenEditting = true
        phoneNumberTextField.backgroundColor = .lotion
        phoneNumberTextField.borderColor = .crayola
        phoneNumberTextField.textField.paddingLeft = 10
        phoneNumberTextField.cornerRadius = 12
        phoneNumberTextField.leftButtonWidth = 80.0
        phoneNumberTextField.delegate = self
        self.becomeFirstResponder()
        return phoneNumberTextField
    }()

    private lazy var confirmLabel: UILabel = {
        let confirmLabel = UILabel()
        confirmLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmLabel.text = "Sign in"
        confirmLabel.backgroundColor = .lotion
        confirmLabel.textColor = .crayola
        confirmLabel.textAlignment = .center
        confirmLabel.font = Outfit.regularFont(size: 20)

        return confirmLabel
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Login to your Account"
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = .black
        titleLabel.font = Outfit.boldFont(size: 40)
        titleLabel.textAlignment = .left
        return titleLabel
    }()

    // MARK: - Variables
    private var isRememberMe = false
    weak var delegate: LoginByPasswordViewDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addContentView()
        self.addLayoutConstraints()
        self.config()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addContentView()
        self.addLayoutConstraints()
        self.config()
    }

    private func addContentView() {
        self.addSubview(self.containerView)

        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.phoneNumberTextField)
        self.containerView.addSubview(self.confirmButton)

        self.confirmButton.addSubview(self.confirmLabel)
    }

    // MARK: - Constraints
    private func addLayoutConstraints() {
        self.containerView.fitSuperviewConstraint()
        self.confirmLabel.fitSuperviewConstraint()

        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                     constant: Const.leftPadding),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor,
                                                      constant: Const.rightPadding),

            self.phoneNumberTextField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,
                                                     constant: 40.0),
            self.phoneNumberTextField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                         constant: Const.leftPadding),
            self.phoneNumberTextField.heightAnchor.constraint(equalToConstant: 60.0),
            self.phoneNumberTextField.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),

            self.confirmButton.topAnchor.constraint(equalTo: self.phoneNumberTextField.bottomAnchor,
                                                    constant: 20.0),
            self.confirmButton.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.confirmButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                        constant: Const.leftPadding),
            self.confirmButton.heightAnchor.constraint(equalToConstant: 50.0),
            self.confirmButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
        ])
    }

    private func config() {

        self.phoneNumberTextField.isLeftButtonEnable = true
        self.phoneNumberTextField.setLeftImage(image: UIImage(named: "ic_vietnam_phone"))
        self.phoneNumberTextField.paddingLeft = 95.0
        self.phoneNumberTextField.keyboardType = .decimalPad
        self.phoneNumberTextField.font = Outfit.regularFont(size: 20.0)
        self.phoneNumberTextField.cornerRadius = 16.0
    }

    // MARK: - Actions
    @objc func didTapConfirmButton(_ sender: Any) {
        self.delegate?.loginByPasswordViewDidTapConfirm(self,
                                                        phoneNumber: self.phoneNumberTextField.text)
    }

    // MARK: - Helps
    func validatePhoneNumber() -> Bool {
        return self.phoneNumberTextField.text.isPhoneNumberValid()
    }

    // MARK: - Public
    public func bindData(title: String, confirmContent: String) {
        self.titleLabel.text = title
        self.confirmLabel.text = confirmContent
    }
}

// MARK: - SolarTextFieldDelegate
extension LoginByPasswordView: SolarTextFieldDelegate {
    func solarTextField(_ textField: SolarTextField, willChangeToText text: String) -> Bool {
        return true
    }

    func solarTextFieldDidChangeValue(_ textField: SolarTextField) {
        let isValidInput = self.validatePhoneNumber()
        self.confirmButton.isUserInteractionEnabled = isValidInput
        self.confirmLabel.backgroundColor = isValidInput ? .crayola : .lotion
        self.confirmLabel.textColor = isValidInput ? .lotion : .crayola
    }
}
