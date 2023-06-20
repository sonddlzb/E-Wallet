//
//  ChatDetailsRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 19/06/2023.
//

import RIBs

protocol ChatDetailsInteractable: Interactable, TransactionDetailsListener {
    var router: ChatDetailsRouting? { get set }
    var listener: ChatDetailsListener? { get set }
}

protocol ChatDetailsViewControllable: ViewControllable {
}

final class ChatDetailsRouter: ViewableRouter<ChatDetailsInteractable, ChatDetailsViewControllable> {
    private var transactionDetailsRouter: TransactionDetailsRouting?
    private var transactionDetailsBuilder: TransactionDetailsBuildable

    init(interactor: ChatDetailsInteractable,
         viewController: ChatDetailsViewControllable,
         transactionDetailsBuilder: TransactionDetailsBuildable) {
        self.transactionDetailsBuilder = transactionDetailsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension ChatDetailsRouter: ChatDetailsRouting {
    func openHistory(at transaction: Transaction) {
        guard self.transactionDetailsRouter == nil else {
            return
        }

        let router = self.transactionDetailsBuilder.build(withListener: self.interactor, transaction: transaction)
        self.attachChild(router)
        self.viewControllable.push(viewControllable: router.viewControllable)
        self.transactionDetailsRouter = router
    }

    func dismissHistory() {
        guard let router = self.transactionDetailsRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.popToBefore(viewControllable: router.viewControllable)
        self.transactionDetailsRouter = nil
    }
}
