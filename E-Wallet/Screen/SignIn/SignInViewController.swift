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
}

// MARK: -
extension SignInViewController: LoginByPasswordViewDelegate {
    func loginByPasswordViewDidTapConfirm(_ loginByPasswordView: LoginByPasswordView, phoneNumber: String, password: String) {
        // validate and login here
    }
}
