//
//  TransactionDetailsRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 27/04/2023.
//

import RIBs

protocol TransactionDetailsInteractable: Interactable {
    var router: TransactionDetailsRouting? { get set }
    var listener: TransactionDetailsListener? { get set }
}

protocol TransactionDetailsViewControllable: ViewControllable {
}

final class TransactionDetailsRouter: ViewableRouter<TransactionDetailsInteractable, TransactionDetailsViewControllable>, TransactionDetailsRouting {
    
    override init(interactor: TransactionDetailsInteractable, viewController: TransactionDetailsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
