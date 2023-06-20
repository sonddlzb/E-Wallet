//
//  ChatDetailsRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 19/06/2023.
//

import RIBs

protocol ChatDetailsInteractable: Interactable {
    var router: ChatDetailsRouting? { get set }
    var listener: ChatDetailsListener? { get set }
}

protocol ChatDetailsViewControllable: ViewControllable {
}

final class ChatDetailsRouter: ViewableRouter<ChatDetailsInteractable, ChatDetailsViewControllable>, ChatDetailsRouting {
    
    override init(interactor: ChatDetailsInteractable, viewController: ChatDetailsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
