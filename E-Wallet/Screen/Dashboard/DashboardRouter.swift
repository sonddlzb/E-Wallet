//
//  DashboardRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import RIBs

protocol DashboardInteractable: Interactable {
    var router: DashboardRouting? { get set }
    var listener: DashboardListener? { get set }
}

protocol DashboardViewControllable: ViewControllable {
}

final class DashboardRouter: ViewableRouter<DashboardInteractable, DashboardViewControllable>, DashboardRouting {
    
    override init(interactor: DashboardInteractable, viewController: DashboardViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
