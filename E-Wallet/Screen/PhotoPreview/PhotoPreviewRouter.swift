//
//  PhotoPreviewRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 08/07/2023.
//

import RIBs

protocol PhotoPreviewInteractable: Interactable {
    var router: PhotoPreviewRouting? { get set }
    var listener: PhotoPreviewListener? { get set }
}

protocol PhotoPreviewViewControllable: ViewControllable {
}

final class PhotoPreviewRouter: ViewableRouter<PhotoPreviewInteractable, PhotoPreviewViewControllable>, PhotoPreviewRouting {
    
    override init(interactor: PhotoPreviewInteractable, viewController: PhotoPreviewViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
