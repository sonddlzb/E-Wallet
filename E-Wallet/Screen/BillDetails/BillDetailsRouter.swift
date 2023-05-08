//
//  BillDetailsRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 08/05/2023.
//

import RIBs

protocol BillDetailsInteractable: Interactable {
    var router: BillDetailsRouting? { get set }
    var listener: BillDetailsListener? { get set }
}

protocol BillDetailsViewControllable: ViewControllable {
}

final class BillDetailsRouter: ViewableRouter<BillDetailsInteractable, BillDetailsViewControllable>, BillDetailsRouting {
    
    override init(interactor: BillDetailsInteractable, viewController: BillDetailsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
