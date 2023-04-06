//
//  VerifyCodeRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 06/04/2023.
//

import RIBs

protocol VerifyCodeInteractable: Interactable {
    var router: VerifyCodeRouting? { get set }
    var listener: VerifyCodeListener? { get set }
}

protocol VerifyCodeViewControllable: ViewControllable {
}

final class VerifyCodeRouter: ViewableRouter<VerifyCodeInteractable, VerifyCodeViewControllable>, VerifyCodeRouting {
    
    override init(interactor: VerifyCodeInteractable, viewController: VerifyCodeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
