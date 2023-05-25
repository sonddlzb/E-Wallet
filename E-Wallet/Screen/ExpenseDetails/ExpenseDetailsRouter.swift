//
//  ExpenseDetailsRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 24/05/2023.
//

import RIBs

protocol ExpenseDetailsInteractable: Interactable {
    var router: ExpenseDetailsRouting? { get set }
    var listener: ExpenseDetailsListener? { get set }
}

protocol ExpenseDetailsViewControllable: ViewControllable {
}

final class ExpenseDetailsRouter: ViewableRouter<ExpenseDetailsInteractable, ExpenseDetailsViewControllable>, ExpenseDetailsRouting {
    
    override init(interactor: ExpenseDetailsInteractable, viewController: ExpenseDetailsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
