//
//  FeedbackRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 17/07/2023.
//

import RIBs

protocol FeedbackInteractable: Interactable {
    var router: FeedbackRouting? { get set }
    var listener: FeedbackListener? { get set }
}

protocol FeedbackViewControllable: ViewControllable {
}

final class FeedbackRouter: ViewableRouter<FeedbackInteractable, FeedbackViewControllable>, FeedbackRouting {
    
    override init(interactor: FeedbackInteractable, viewController: FeedbackViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
