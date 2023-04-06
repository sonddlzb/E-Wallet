//
//  SignInInteractor.swift
//  E-Wallet
//
//  Created by đào sơn on 05/04/2023.
//

import RIBs
import RxSwift

protocol SignInRouting: ViewableRouting {
}

protocol SignInPresentable: Presentable {
    var listener: SignInPresentableListener? { get set }
}

protocol SignInListener: AnyObject {
    func signInWantToRouteToSignUp()
}

final class SignInInteractor: PresentableInteractor<SignInPresentable>, SignInInteractable {

    weak var router: SignInRouting?
    weak var listener: SignInListener?

    override init(presenter: SignInPresentable) {
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

// MARK: - SignInPresentableListener
extension SignInInteractor: SignInPresentableListener {
    func routeToSignUp() {
        self.listener?.signInWantToRouteToSignUp()
    }
}
