//
//  EnterBillRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 05/05/2023.
//

import RIBs

protocol EnterBillInteractable: Interactable, BillDetailsListener {
    var router: EnterBillRouting? { get set }
    var listener: EnterBillListener? { get set }
}

protocol EnterBillViewControllable: ViewControllable {
}

final class EnterBillRouter: ViewableRouter<EnterBillInteractable, EnterBillViewControllable> {

    private var billDetailsRouter: BillDetailsRouting?
    private var billDetailsBuilder: BillDetailsBuildable
    
    init(interactor: EnterBillInteractable,
         viewController: EnterBillViewControllable,
         billDetailsBuilder: BillDetailsBuildable) {
        self.billDetailsBuilder = billDetailsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - EnterBillRouting
extension EnterBillRouter: EnterBillRouting {
    func routeToBillDetails(bill: Bill) {
        guard self.billDetailsRouter == nil else {
            return
        }

        let router = self.billDetailsBuilder.build(withListener: self.interactor, bill: bill)
        self.attachChild(router)
        self.viewControllable.push(viewControllable: router.viewControllable)
        self.billDetailsRouter = router
    }

    func dismissBillDetails() {
        guard let router = self.billDetailsRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.popToBefore(viewControllable: router.viewControllable)
        self.billDetailsRouter = nil
    }
}
