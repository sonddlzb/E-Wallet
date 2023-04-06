//
//  SignInViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 05/04/2023.
//

import RIBs
import RxSwift
import UIKit

protocol SignInPresentableListener: AnyObject {
    func routeToSignUp()
}

final class SignInViewController: BaseViewControler, SignInPresentable, SignInViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var loginByPasswordView: LoginByPasswordView!

    // MARK: - Variables
    weak var listener: SignInPresentableListener?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.loginByPasswordView.delegate = self
    }

    // MARK: - Actions
    @IBAction func didTapSignUpButton(_ sender: Any) {
        self.listener?.routeToSignUp()
    }
}

// MARK: - LoginByPasswordViewDelegate
extension SignInViewController: LoginByPasswordViewDelegate {
    func loginByPasswordViewDidTapConfirm(_ loginByPasswordView: LoginByPasswordView, phoneNumber: String, password: String) {
        // validate and login here
    }
}

extension SignInViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
