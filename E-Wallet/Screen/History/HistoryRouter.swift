//
//  HistoryRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 25/04/2023.
//

import RIBs

protocol HistoryInteractable: Interactable, TransactionDetailsListener, FilterListener {
    var router: HistoryRouting? { get set }
    var listener: HistoryListener? { get set }
}

protocol HistoryViewControllable: ViewControllable {
}

final class HistoryRouter: ViewableRouter<HistoryInteractable, HistoryViewControllable> {

    private var transactionDetailsRouter: TransactionDetailsRouting?
    private var transactionDetailsBuilder: TransactionDetailsBuildable

    private var filterRouter: FilterRouting?
    private var filterBuilder: FilterBuildable

    init(interactor: HistoryInteractable,
         viewController: HistoryViewControllable,
         transactionDetailsBuilder: TransactionDetailsBuildable,
         filterBuilder: FilterBuildable) {
        self.transactionDetailsBuilder = transactionDetailsBuilder
        self.filterBuilder = filterBuilder
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

    func routeToFilter(filterModel: FilterModel?) {
        guard self.filterRouter == nil else {
            return
        }

        let router = self.filterBuilder.build(withListener: self.interactor, filterModel: filterModel)
        router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
        self.viewController.uiviewController.present(router.viewControllable.uiviewController, animated: true)
        self.attachChild(router)
        self.filterRouter = router
    }

    func dismissFilter() {
        guard let router = self.filterRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.uiviewController.dismiss(animated: true)
        self.filterRouter = nil
    }
}
