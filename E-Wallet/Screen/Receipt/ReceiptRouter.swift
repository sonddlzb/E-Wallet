//
//  ReceiptRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 21/04/2023.
//

import RIBs

protocol ReceiptInteractable: Interactable {
    var router: ReceiptRouting? { get set }
    var listener: ReceiptListener? { get set }
}

protocol ReceiptViewControllable: ViewControllable {
}

final class ReceiptRouter: ViewableRouter<ReceiptInteractable, ReceiptViewControllable>, ReceiptRouting {
    
    override init(interactor: ReceiptInteractable, viewController: ReceiptViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
