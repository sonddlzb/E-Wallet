//
//  VoucherDetailsRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 05/05/2023.
//

import RIBs

protocol VoucherDetailsInteractable: Interactable {
    var router: VoucherDetailsRouting? { get set }
    var listener: VoucherDetailsListener? { get set }
}

protocol VoucherDetailsViewControllable: ViewControllable {
}

final class VoucherDetailsRouter: ViewableRouter<VoucherDetailsInteractable, VoucherDetailsViewControllable>, VoucherDetailsRouting {
    
    override init(interactor: VoucherDetailsInteractable, viewController: VoucherDetailsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
