//
//  CardDetailsRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 16/04/2023.
//

import RIBs

protocol CardDetailsInteractable: Interactable {
    var router: CardDetailsRouting? { get set }
    var listener: CardDetailsListener? { get set }
}

protocol CardDetailsViewControllable: ViewControllable {
}

final class CardDetailsRouter: ViewableRouter<CardDetailsInteractable, CardDetailsViewControllable>, CardDetailsRouting {
    
    override init(interactor: CardDetailsInteractable, viewController: CardDetailsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
