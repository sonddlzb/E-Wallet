//
//  HistoryRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 25/04/2023.
//

import RIBs

protocol HistoryInteractable: Interactable {
    var router: HistoryRouting? { get set }
    var listener: HistoryListener? { get set }
}

protocol HistoryViewControllable: ViewControllable {
}

final class HistoryRouter: ViewableRouter<HistoryInteractable, HistoryViewControllable>, HistoryRouting {
    
    override init(interactor: HistoryInteractable, viewController: HistoryViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
