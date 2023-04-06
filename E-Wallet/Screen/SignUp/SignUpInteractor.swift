//
//  SignUpInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 06/04/2023.
//

import RIBs
import RxSwift

protocol SignUpRouting: ViewableRouting {
}

protocol SignUpPresentable: Presentable {
    var listener: SignUpPresentableListener? { get set }
}

protocol SignUpListener: AnyObject {
    func signUpWantToRouteToSignIn()
}

final class SignUpInteractor: PresentableInteractor<SignUpPresentable>, SignUpInteractable {

    weak var router: SignUpRouting?
    weak var listener: SignUpListener?

    override init(presenter: SignUpPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - SignUpPresentableListener
extension SignUpInteractor: SignUpPresentableListener {
    func routeToSignIn() {
        self.listener?.signUpWantToRouteToSignIn()
    }
}
