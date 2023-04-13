//
//  EditProfileRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 12/04/2023.
//

import RIBs

protocol EditProfileInteractable: Interactable {
    var router: EditProfileRouting? { get set }
    var listener: EditProfileListener? { get set }
}

protocol EditProfileViewControllable: ViewControllable {
}

final class EditProfileRouter: ViewableRouter<EditProfileInteractable, EditProfileViewControllable>, EditProfileRouting {
    
    override init(interactor: EditProfileInteractable, viewController: EditProfileViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
