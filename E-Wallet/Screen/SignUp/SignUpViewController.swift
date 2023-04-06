//
//  SignUpViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 06/04/2023.
//

import RIBs
import RxSwift
import UIKit

protocol SignUpPresentableListener: AnyObject {
    func routeToSignIn()
    func signUpWithPhoneNumber(_ phoneNumber: String)
}

final class SignUpViewController: UIViewController, SignUpPresentable, SignUpViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var loginByPasswordView: LoginByPasswordView!

    // MARK: - Variables
    weak var listener: SignUpPresentableListener?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.loginByPasswordView.bindData(title: "Create your account", confirmContent: "Sign Up")
        self.loginByPasswordView.delegate = self
    }

    // MARK: - Actions
    @IBAction func didTapSignInButton(_ sender: Any) {
        self.listener?.routeToSignIn()
    }

    // MARK: - Helper
    func formatPhoneNumber(_ phoneNumber: String) -> String {
        return "+84" + (phoneNumber.first == "0" ?  String(phoneNumber.dropFirst()) : phoneNumber)
    }
}

extension SignUpViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - LoginByPasswordViewDelegate
extension SignUpViewController: LoginByPasswordViewDelegate {
    func loginByPasswordViewDidTapConfirm(_ loginByPasswordView: LoginByPasswordView, phoneNumber: String) {
            self.listener?.signUpWithPhoneNumber(self.formatPhoneNumber(phoneNumber))
    }
}
