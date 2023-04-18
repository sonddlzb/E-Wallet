//
//  WithdrawRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import RIBs

protocol WithdrawInteractable: Interactable {
    var router: WithdrawRouting? { get set }
    var listener: WithdrawListener? { get set }

    func reloadData()
    func bind(homeViewModel: HomeViewModel)
}

protocol WithdrawViewControllable: ViewControllable {
}

final class WithdrawRouter: ViewableRouter<WithdrawInteractable, WithdrawViewControllable> {
    
    override init(interactor: WithdrawInteractable, viewController: WithdrawViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - WithdrawRouting
extension WithdrawRouter: WithdrawRouting {
    func reloadData() {
        self.interactor.reloadData()
    }

    func bind(homeViewModel: HomeViewModel) {
        self.interactor.bind(homeViewModel: homeViewModel)
    }
}
