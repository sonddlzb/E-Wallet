//
//  ChatRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 11/06/2023.
//

import RIBs

protocol ChatInteractable: Interactable {
    var router: ChatRouting? { get set }
    var listener: ChatListener? { get set }
}

protocol ChatViewControllable: ViewControllable {
}

final class ChatRouter: ViewableRouter<ChatInteractable, ChatViewControllable>, ChatRouting {
    
    override init(interactor: ChatInteractable, viewController: ChatViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
