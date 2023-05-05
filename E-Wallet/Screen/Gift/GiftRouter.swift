//
//  GiftRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 04/05/2023.
//

import RIBs

protocol GiftInteractable: Interactable, VoucherDetailsListener {
    var router: GiftRouting? { get set }
    var listener: GiftListener? { get set }
}

protocol GiftViewControllable: ViewControllable {
}

final class GiftRouter: ViewableRouter<GiftInteractable, GiftViewControllable> {

    private var voucherDetailsRouter: VoucherDetailsRouting?
    private var voucherDetailsBuilder: VoucherDetailsBuildable

    init(interactor: GiftInteractable,
         viewController: GiftViewControllable,
         voucherDetailsBuilder: VoucherDetailsBuildable) {
        self.voucherDetailsBuilder = voucherDetailsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - GiftRouting
extension GiftRouter: GiftRouting {
    func routeToVoucherDetails(voucher: Voucher) {
        guard self.voucherDetailsRouter == nil else {
            return
        }

        let router = self.voucherDetailsBuilder.build(withListener: self.interactor, voucher: voucher)
        self.attachChild(router)
        self.viewControllable.push(viewControllable: router.viewControllable)
        self.voucherDetailsRouter = router
    }

    func dissmissVoucherDetails() {
        guard let router = self.voucherDetailsRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.popToBefore(viewControllable: router.viewControllable)
        self.voucherDetailsRouter = nil
    }
}
