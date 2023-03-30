//
//  SignInRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 05/04/2023.
//

import RIBs

protocol SignInInteractable: Interactable {
    var router: SignInRouting? { get set }
    var listener: SignInListener? { get set }
}

protocol SignInViewControllable: ViewControllable {
}

final class SignInRouter: ViewableRouter<SignInInteractable, SignInViewControllable>, SignInRouting {
    
    override init(interactor: SignInInteractable, viewController: SignInViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
