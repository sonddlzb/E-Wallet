//
//  ExpenseRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 15/05/2023.
//

import RIBs

protocol ExpenseInteractable: Interactable {
    var router: ExpenseRouting? { get set }
    var listener: ExpenseListener? { get set }
}

protocol ExpenseViewControllable: ViewControllable {
}

final class ExpenseRouter: ViewableRouter<ExpenseInteractable, ExpenseViewControllable>, ExpenseRouting {
    
    override init(interactor: ExpenseInteractable, viewController: ExpenseViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
