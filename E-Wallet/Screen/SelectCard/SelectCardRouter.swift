//
//  SelectCardRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 19/04/2023.
//

import RIBs

protocol SelectCardInteractable: Interactable {
    var router: SelectCardRouting? { get set }
    var listener: SelectCardListener? { get set }
}

protocol SelectCardViewControllable: ViewControllable {
}

final class SelectCardRouter: ViewableRouter<SelectCardInteractable, SelectCardViewControllable>, SelectCardRouting {
    
    override init(interactor: SelectCardInteractable, viewController: SelectCardViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
