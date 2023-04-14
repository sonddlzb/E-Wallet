//
//  AddCardRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import RIBs

protocol AddCardInteractable: Interactable {
    var router: AddCardRouting? { get set }
    var listener: AddCardListener? { get set }
}

protocol AddCardViewControllable: ViewControllable {
}

final class AddCardRouter: ViewableRouter<AddCardInteractable, AddCardViewControllable>, AddCardRouting {
    
    override init(interactor: AddCardInteractable, viewController: AddCardViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
