//
//  ExpenseRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 15/05/2023.
//

import RIBs

protocol ExpenseInteractable: Interactable, ExpenseDetailsListener {
    var router: ExpenseRouting? { get set }
    var listener: ExpenseListener? { get set }
}

protocol ExpenseViewControllable: ViewControllable {
}

final class ExpenseRouter: ViewableRouter<ExpenseInteractable, ExpenseViewControllable> {

    private var expenseDetailsRouter: ExpenseDetailsRouting?
    private var expenseDetailsBuilder: ExpenseDetailsBuildable

    init(interactor: ExpenseInteractable,
         viewController: ExpenseViewControllable,
         expenseDetailsBuilder: ExpenseDetailsBuildable) {
        self.expenseDetailsBuilder = expenseDetailsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - ExpenseRouting
extension ExpenseRouter: ExpenseRouting {
    func routeToExpenseDetails(startDate: Date) {
        guard self.expenseDetailsRouter == nil else {
            return
        }

        let router = self.expenseDetailsBuilder.build(withListener: self.interactor, startDate: startDate)
        self.attachChild(router)
        self.viewControllable.push(viewControllable: router.viewControllable)
        self.expenseDetailsRouter = router
    }

    func dismissExpenseDetails() {
        guard let router = self.expenseDetailsRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.popToBefore(viewControllable: router.viewControllable)
        self.expenseDetailsRouter = nil
    }
}
