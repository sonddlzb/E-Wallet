//
//  EnterPasswordInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 07/04/2023.
//

import RIBs
import RxSwift

protocol EnterPasswordRouting: ViewableRouting {
    func bindSignInResult(isSuccess: Bool)
}

protocol EnterPasswordPresentable: Presentable {
    var listener: EnterPasswordPresentableListener? { get set }

    func bind(viewModel: EnterPasswordViewModel)
    func bindSignInResult(isSuccess: Bool, chances: Int)
}

protocol EnterPasswordListener: AnyObject {
    func enterPasswordWantToDissmiss()
    func enterPasswordWantToConfirmPassword(password: String)
    func enterPasswordDidConfirmPasswordSuccessfully(password: String)
    func enterPasswordWantToAuthenticateOldUser(password: String)
    func enterPasswordWantToRouteToHome()
}

final class EnterPasswordInteractor: PresentableInteractor<EnterPasswordPresentable> {

    weak var router: EnterPasswordRouting?
    weak var listener: EnterPasswordListener?
    private var viewModel: EnterPasswordViewModel
    private var chances = 5

    init(presenter: EnterPasswordPresentable,
         isNewUser: Bool,
         isConfirmPassword: Bool,
         password: String) {
        self.viewModel = EnterPasswordViewModel(isNewUser: isNewUser, isConfirmPassword: isConfirmPassword)
        self.viewModel.password = password
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.presenter.bind(viewModel: self.viewModel)
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - EnterPasswordPresentableListener
extension EnterPasswordInteractor: EnterPasswordPresentableListener {
    func enterPasswordWantToDissmiss() {
        self.listener?.enterPasswordWantToDissmiss()
    }

    func enterPasswordWantToConfirmPassword(password: String) {
        self.listener?.enterPasswordWantToConfirmPassword(password: password)
    }

    func enterPasswordDidConfirmPasswordSuccessfully(password: String) {
        self.listener?.enterPasswordDidConfirmPasswordSuccessfully(password: password)
    }

    func enterPasswordWantToAuthenticateOldUser(password: String) {
        self.listener?.enterPasswordWantToAuthenticateOldUser(password: password)
    }

    func enterPasswordWantToRouteToHome() {
        self.listener?.enterPasswordWantToRouteToHome()
    }
}

// MARK: - EnterPasswordInteractable
extension EnterPasswordInteractor: EnterPasswordInteractable {
    func bindSignInResult(isSuccess: Bool) {
        if !isSuccess {
            self.chances -= 1
        }

        if chances <= 0 {
            self.enterPasswordWantToDissmiss()
            return
        }

        self.presenter.bindSignInResult(isSuccess: isSuccess, chances: self.chances)
    }
}
