//
//  ScannerRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 11/05/2023.
//

import RIBs

protocol ScannerInteractable: Interactable {
    var router: ScannerRouting? { get set }
    var listener: ScannerListener? { get set }
}

protocol ScannerViewControllable: ViewControllable {
}

final class ScannerRouter: ViewableRouter<ScannerInteractable, ScannerViewControllable>, ScannerRouting {
    
    override init(interactor: ScannerInteractable, viewController: ScannerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
