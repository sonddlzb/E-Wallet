//
//  ProfileRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import RIBs

protocol ProfileInteractable: Interactable {
    var router: ProfileRouting? { get set }
    var listener: ProfileListener? { get set }
}

protocol ProfileViewControllable: ViewControllable {
}

final class ProfileRouter: ViewableRouter<ProfileInteractable, ProfileViewControllable>, ProfileRouting {
    
    override init(interactor: ProfileInteractable, viewController: ProfileViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
