//
//  GiftRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 04/05/2023.
//

import RIBs

protocol GiftInteractable: Interactable {
    var router: GiftRouting? { get set }
    var listener: GiftListener? { get set }
}

protocol GiftViewControllable: ViewControllable {
}

final class GiftRouter: ViewableRouter<GiftInteractable, GiftViewControllable>, GiftRouting {
    
    override init(interactor: GiftInteractable, viewController: GiftViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
