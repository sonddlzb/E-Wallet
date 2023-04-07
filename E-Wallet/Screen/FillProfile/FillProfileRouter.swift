//
//  FillProfileRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 07/04/2023.
//

import RIBs

protocol FillProfileInteractable: Interactable {
    var router: FillProfileRouting? { get set }
    var listener: FillProfileListener? { get set }

    func bindSignUpResult(isSuccess: Bool)
}

protocol FillProfileViewControllable: ViewControllable {
}

final class FillProfileRouter: ViewableRouter<FillProfileInteractable, FillProfileViewControllable> {
    override init(interactor: FillProfileInteractable, viewController: FillProfileViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - FillProfileRouting
extension FillProfileRouter: FillProfileRouting {
    func bindSignUpResult(isSuccess: Bool) {
        self.interactor.bindSignUpResult(isSuccess: isSuccess)
    }
}
