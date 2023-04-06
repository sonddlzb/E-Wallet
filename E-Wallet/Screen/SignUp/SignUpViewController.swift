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
    }

    // MARK: - Actions
    @IBAction func didTapSignInButton(_ sender: Any) {
        self.listener?.routeToSignIn()
    }
}

extension SignUpViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
