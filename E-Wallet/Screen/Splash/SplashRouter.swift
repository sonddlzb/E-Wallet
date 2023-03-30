//
//  SplashRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 05/04/2023.
//

import RIBs

protocol SplashInteractable: Interactable {
    var router: SplashRouting? { get set }
    var listener: SplashListener? { get set }
}

protocol SplashViewControllable: ViewControllable {
}

final class SplashRouter: ViewableRouter<SplashInteractable, SplashViewControllable>, SplashRouting {
    
    override init(interactor: SplashInteractable, viewController: SplashViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
