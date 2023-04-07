//
//  EnterPasswordViewController.swift
//  E-Wallet
//
//  Created by đào sơn on 07/04/2023.
//

import RIBs
import RxSwift
import UIKit

protocol EnterPasswordPresentableListener: AnyObject {
    func enterPasswordWantToDissmiss()
    func enterPasswordWantToConfirmPassword(password: String)
    func enterPasswordDidConfirmPasswordSuccessfully(password: String)
    func enterPasswordWantToAuthenticateOldUser(password: String)
}

final class EnterPasswordViewController: UIViewController, EnterPasswordViewControllable {

    // MARK: - Outlets
    @IBOutlet private weak var passwordView: PasswordView!
    @IBOutlet private weak var cancelButton: TapableView!

    // MARK: - Variables
    weak var listener: EnterPasswordPresentableListener?
    private var viewModel = EnterPasswordViewModel()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    // MARK: - Config
    private func config() {
        self.passwordView.delegate = self
    }

    // MARK: - Actions
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.listener?.enterPasswordWantToDissmiss()
    }
}

// MARK: - PasswordViewDelegate
extension EnterPasswordViewController: PasswordViewDelegate {
    func passwordViewDidEnterPassword(_ passwordView: PasswordView, password: String) {
        print("Current password \(password)")
        if self.viewModel.isNewUser {
            if !self.viewModel.isConfirmPassword {
                self.listener?.enterPasswordWantToConfirmPassword(password: password)
            } else {
                if password == self.viewModel.password {
                    self.listener?.enterPasswordDidConfirmPasswordSuccessfully(password: password)
                } else {
                    FailedDialog.show(title: "Password not matched", message: "Please check your password and try again!")
                    self.passwordView.reset()
                }
            }
        } else {
            self.listener?.enterPasswordWantToAuthenticateOldUser(password: password)
        }
    }
}

// MARK: - EnterPasswordPresentable
extension EnterPasswordViewController: EnterPasswordPresentable {
    func bind(viewModel: EnterPasswordViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        var title = ""
        if self.viewModel.isConfirmPassword {
            title = "Confirm your password"
            self.cancelButton.isHidden = true
        } else if self.viewModel.isNewUser {
            title = "Create your password"
            self.cancelButton.isHidden = true
        } else {
            title = "Enter your password"
            self.cancelButton.isHidden = false
        }

        self.passwordView.bind(title: title)
    }

    func bindSignInResult(isSuccess: Bool, chances: Int) {
        if !isSuccess {
            FailedDialog.show(title: "Incorrect Password", message: "Please check your password and try again! You have \(chances) chances left.")
            self.passwordView.reset()
        } else {
            print("route to Home")
            // route to Home
        }
    }
}
