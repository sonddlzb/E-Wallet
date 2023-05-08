//
//  EnterBillRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 05/05/2023.
//

import RIBs

protocol EnterBillInteractable: Interactable {
    var router: EnterBillRouting? { get set }
    var listener: EnterBillListener? { get set }
}

protocol EnterBillViewControllable: ViewControllable {
}

final class EnterBillRouter: ViewableRouter<EnterBillInteractable, EnterBillViewControllable>, EnterBillRouting {
    
    override init(interactor: EnterBillInteractable, viewController: EnterBillViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
