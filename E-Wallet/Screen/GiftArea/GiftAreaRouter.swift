//
//  GiftAreaRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 18/07/2023.
//

import RIBs

protocol GiftAreaInteractable: Interactable {
    var router: GiftAreaRouting? { get set }
    var listener: GiftAreaListener? { get set }
}

protocol GiftAreaViewControllable: ViewControllable {
}

final class GiftAreaRouter: ViewableRouter<GiftAreaInteractable, GiftAreaViewControllable>, GiftAreaRouting {
    
    override init(interactor: GiftAreaInteractable, viewController: GiftAreaViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
