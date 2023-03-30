//
//  LoginByPasswordView.swift
//  TestCustomView
//
//  Created by đào sơn on 03/03/2023.
//

import UIKit

private struct Const {
    static let leftPadding = 20.0
    static let rightPadding = -50.0
}

protocol LoginByPasswordViewDelegate: AnyObject {
    func loginByPasswordViewDidTapConfirm(_ loginByPasswordView: LoginByPasswordView, email: String, password: String)
}

class LoginByPasswordView: UIView {
    // MARK: - Outlets
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    private lazy var rememberContainerView: UIView = {
        let rememberContainerView = UIView()
        rememberContainerView.translatesAutoresizingMaskIntoConstraints = false
        return rememberContainerView
    }()

    private lazy var confirmButton: TapableView = {
        let confirmButton = TapableView()
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.cornerRadius = 20
        confirmButton.isUserInteractionEnabled = false
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton(_:)), for: .touchUpInside)
        return confirmButton
    }()

    private lazy var rememberButton: TapableView = {
        let rememberButton = TapableView()
        rememberButton.translatesAutoresizingMaskIntoConstraints = false
        rememberButton.addTarget(self, action: #selector(didTapRememberButton(_:)), for: .touchUpInside)
        return rememberButton
    }()

    private lazy var emailTextField: SolarTextField = {
        let emailTextField = SolarTextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Email"
        emailTextField.isHighlightedWhenEditting = true
        emailTextField.backgroundColor = .lotion
        emailTextField.borderColor = .crayola
        emailTextField.textField.paddingLeft = 10
        emailTextField.cornerRadius = 12
        emailTextField.delegate = self
        self.becomeFirstResponder()
        return emailTextField
    }()

    private lazy var passwordTextField: PasswordTextField = {
        let passwordTextField = PasswordTextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.isHighlightedWhenEditting = true
        passwordTextField.backgroundColor = .lotion
        passwordTextField.borderColor = .crayola
        passwordTextField.textField.paddingLeft = 10
        passwordTextField.cornerRadius = 12
        passwordTextField.isSecureText = true
        passwordTextField.delegate = self

        return passwordTextField
    }()

    private lazy var rememberImageView: UIImageView = {
        let rememberImageView = UIImageView()
        rememberImageView.translatesAutoresizingMaskIntoConstraints = false
        rememberImageView.borderColor = .crayola
        rememberImageView.borderWidth = 2
        rememberImageView.cornerRadius = 5

        return rememberImageView
    }()

    private lazy var confirmLabel: UILabel = {
        let confirmLabel = UILabel()
        confirmLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmLabel.text = "Sign in"
        confirmLabel.backgroundColor = .lotion
        confirmLabel.textColor = .white
        confirmLabel.textAlignment = .center
        confirmLabel.font = Outfit.regularFont(size: 14)

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

    private lazy var rememberLabel: UILabel = {
        let rememberLabel = UILabel()
        rememberLabel.translatesAutoresizingMaskIntoConstraints = false
        rememberLabel.text = "Remember me"
        rememberLabel.textAlignment = .center
        rememberLabel.font = Outfit.regularFont(size: 14)
        return rememberLabel
    }()

    // MARK: - Variables
    private var isRememberMe = false
    weak var delegate: LoginByPasswordViewDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addContentView()
        self.addLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addContentView()
        self.addLayoutConstraints()
    }

    private func addContentView() {
        self.addSubview(self.containerView)

        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.emailTextField)
        self.containerView.addSubview(self.passwordTextField)
        self.containerView.addSubview(self.rememberContainerView)
        self.containerView.addSubview(self.confirmButton)

        self.rememberContainerView.addSubview(self.rememberButton)
        self.rememberContainerView.addSubview(self.rememberLabel)

        self.rememberButton.addSubview(self.rememberImageView)

        self.confirmButton.addSubview(self.confirmLabel)
    }

    // MARK: - Constraints
    private func addLayoutConstraints() {
        self.containerView.fitSuperviewConstraint()
        self.rememberImageView.fitSuperviewConstraint()
        self.confirmLabel.fitSuperviewConstraint()

        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                     constant: Const.leftPadding),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor,
                                                      constant: Const.rightPadding),

            self.emailTextField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,
                                                     constant: 40.0),
            self.emailTextField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                         constant: Const.leftPadding),
            self.emailTextField.heightAnchor.constraint(equalToConstant: 50.0),
            self.emailTextField.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),

            self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor,
                                                        constant: 24.0),
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                            constant: Const.leftPadding),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 50.0),
            self.passwordTextField.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),

            self.rememberContainerView.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor,
                                                            constant: 20.0),
            self.rememberContainerView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.rememberContainerView.heightAnchor.constraint(equalToConstant: 16.0),

            self.rememberButton.topAnchor.constraint(equalTo: self.rememberContainerView.topAnchor),
            self.rememberButton.leadingAnchor.constraint(equalTo: self.rememberContainerView.leadingAnchor),
            self.rememberButton.bottomAnchor.constraint(equalTo: self.rememberContainerView.bottomAnchor),
            self.rememberButton.widthAnchor.constraint(equalTo: self.rememberImageView.heightAnchor),

            self.rememberLabel.topAnchor.constraint(equalTo: self.rememberContainerView.topAnchor),
            self.rememberLabel.trailingAnchor.constraint(equalTo: self.rememberContainerView.trailingAnchor),
            self.rememberLabel.bottomAnchor.constraint(equalTo: self.rememberContainerView.bottomAnchor),
            self.rememberLabel.leadingAnchor.constraint(equalTo: self.rememberImageView.trailingAnchor,
                                                        constant: 10),

            self.confirmButton.topAnchor.constraint(equalTo: self.rememberContainerView.bottomAnchor,
                                                    constant: 20.0),
            self.confirmButton.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.confirmButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                        constant: Const.leftPadding),
            self.confirmButton.heightAnchor.constraint(equalToConstant: 50.0),
            self.confirmButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
        ])
    }

    // MARK: - Actions
    @objc func didTapRememberButton(_ sender: Any) {
        self.isRememberMe = !self.isRememberMe
        self.rememberImageView.image = self.isRememberMe ? UIImage(named: "ic_remember") : nil
    }

    @objc func didTapConfirmButton(_ sender: Any) {
        self.delegate?.loginByPasswordViewDidTapConfirm(self,
                                                        email: self.emailTextField.text,
                                                        password: self.passwordTextField.text)
    }

    // MARK: - Helps
    func isEmailValidate() -> Bool {
        return self.emailTextField.text.isEmailValid()
    }

    func validatePassword() -> Bool {
        return !self.passwordTextField.text.isEmpty
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
        let isValidInput = self.isEmailValidate() && self.validatePassword()
        self.confirmButton.isUserInteractionEnabled = isValidInput
        self.confirmLabel.backgroundColor = isValidInput ? .crayola : .lotion
    }
}
