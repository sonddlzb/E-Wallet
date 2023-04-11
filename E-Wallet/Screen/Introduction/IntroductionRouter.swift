//
//  IntroductionRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import RIBs

protocol IntroductionInteractable: Interactable {
    var router: IntroductionRouting? { get set }
    var listener: IntroductionListener? { get set }
}

protocol IntroductionViewControllable: ViewControllable {
}

final class IntroductionRouter: ViewableRouter<IntroductionInteractable, IntroductionViewControllable>, IntroductionRouting {
    
    override init(interactor: IntroductionInteractable, viewController: IntroductionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
