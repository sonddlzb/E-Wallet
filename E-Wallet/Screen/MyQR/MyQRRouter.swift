//
//  MyQRRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 12/05/2023.
//

import RIBs

protocol MyQRInteractable: Interactable {
    var router: MyQRRouting? { get set }
    var listener: MyQRListener? { get set }
}

protocol MyQRViewControllable: ViewControllable {
}

final class MyQRRouter: ViewableRouter<MyQRInteractable, MyQRViewControllable>, MyQRRouting {
    
    override init(interactor: MyQRInteractable, viewController: MyQRViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
