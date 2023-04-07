//
//  EnterPasswordRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 07/04/2023.
//

import RIBs

protocol EnterPasswordInteractable: Interactable {
    var router: EnterPasswordRouting? { get set }
    var listener: EnterPasswordListener? { get set }

    func bindSignInResult(isSuccess: Bool)
}

protocol EnterPasswordViewControllable: ViewControllable {
}

final class EnterPasswordRouter: ViewableRouter<EnterPasswordInteractable, EnterPasswordViewControllable> {
    
    override init(interactor: EnterPasswordInteractable, viewController: EnterPasswordViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - EnterPasswordRouting
extension EnterPasswordRouter: EnterPasswordRouting {
    func bindSignInResult(isSuccess: Bool) {
        self.interactor.bindSignInResult(isSuccess: isSuccess)
    }
}
