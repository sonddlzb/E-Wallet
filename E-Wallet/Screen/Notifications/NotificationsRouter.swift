//
//  NotificationsRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 30/05/2023.
//

import RIBs

protocol NotificationsInteractable: Interactable, TransactionDetailsListener {
    var router: NotificationsRouting? { get set }
    var listener: NotificationsListener? { get set }
}

protocol NotificationsViewControllable: ViewControllable {
}

final class NotificationsRouter: ViewableRouter<NotificationsInteractable, NotificationsViewControllable> {

    private var transactionDetailsRouter: TransactionDetailsRouting?
    private var transactionDetailsBuilder: TransactionDetailsBuildable

    init(interactor: NotificationsInteractable,
         viewController: NotificationsViewControllable,
         transactionDetailsBuilder: TransactionDetailsBuildable) {
        self.transactionDetailsBuilder = transactionDetailsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension NotificationsRouter: NotificationsRouting {
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
