//
//  TopUpRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 17/04/2023.
//

import RIBs

protocol TopUpInteractable: Interactable {
    var router: TopUpRouting? { get set }
    var listener: TopUpListener? { get set }

    func reloadData()
}

protocol TopUpViewControllable: ViewControllable {
}

final class TopUpRouter: ViewableRouter<TopUpInteractable, TopUpViewControllable> {
    
    override init(interactor: TopUpInteractable, viewController: TopUpViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - TopUpRouting
extension TopUpRouter: TopUpRouting {
    func reloadData() {
        self.interactor.reloadData()
    }
}
