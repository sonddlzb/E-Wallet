//
//  FilterRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 28/04/2023.
//

import RIBs

protocol FilterInteractable: Interactable {
    var router: FilterRouting? { get set }
    var listener: FilterListener? { get set }
}

protocol FilterViewControllable: ViewControllable {
}

final class FilterRouter: ViewableRouter<FilterInteractable, FilterViewControllable>, FilterRouting {
    
    override init(interactor: FilterInteractable, viewController: FilterViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
