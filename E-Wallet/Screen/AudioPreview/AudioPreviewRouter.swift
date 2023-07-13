//
//  AudioPreviewRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 10/07/2023.
//

import RIBs

protocol AudioPreviewInteractable: Interactable {
    var router: AudioPreviewRouting? { get set }
    var listener: AudioPreviewListener? { get set }
}

protocol AudioPreviewViewControllable: ViewControllable {
}

final class AudioPreviewRouter: ViewableRouter<AudioPreviewInteractable, AudioPreviewViewControllable>, AudioPreviewRouting {
    
    override init(interactor: AudioPreviewInteractable, viewController: AudioPreviewViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
