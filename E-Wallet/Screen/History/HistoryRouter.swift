//
//  HistoryRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 25/04/2023.
//

import RIBs

protocol HistoryInteractable: Interactable, TransactionDetailsListener {
    var router: HistoryRouting? { get set }
    var listener: HistoryListener? { get set }
}

protocol HistoryViewControllable: ViewControllable {
}

final class HistoryRouter: ViewableRouter<HistoryInteractable, HistoryViewControllable> {

    private var transactionDetailsRouter: TransactionDetailsRouting?
    private var transactionDetailsBuilder: TransactionDetailsBuildable

    init(interactor: HistoryInteractable,
         viewController: HistoryViewControllable,
         transactionDetailsBuilder: TransactionDetailsBuildable) {
        self.transactionDetailsBuilder = transactionDetailsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension HistoryRouter: HistoryRouting {
    func routeToTransactionDetails(transaction: Transaction, animated: Bool) {
        guard self.transactionDetailsRouter == nil else {
            return
        }

        let router = self.transactionDetailsBuilder.build(withListener: self.interactor,
                                                          transaction: transaction)
        self.attachChild(router)
        self.viewControllable.push(viewControllable: router.viewControllable, animated: animated)
        self.transactionDetailsRouter = router
    }

    func dismissTransactionDetails() {
        guard let router = self.transactionDetailsRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.popToBefore(viewControllable: router.viewControllable)
        self.transactionDetailsRouter = nil
    }
}
