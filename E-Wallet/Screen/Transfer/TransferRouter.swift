//
//  TransferRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 13/04/2023.
//

import RIBs
import Contacts

protocol TransferInteractable: Interactable {
    var router: TransferRouting? { get set }
    var listener: TransferListener? { get set }
}

protocol TransferViewControllable: ViewControllable {
}

final class TransferRouter: ViewableRouter<TransferInteractable, TransferViewControllable> {

    override init(interactor: TransferInteractable, viewController: TransferViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - TransferRouting
extension TransferRouter: TransferRouting {
}
