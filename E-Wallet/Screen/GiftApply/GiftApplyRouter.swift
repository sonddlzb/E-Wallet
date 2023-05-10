//
//  GiftApplyRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 09/05/2023.
//

import RIBs

protocol GiftApplyInteractable: Interactable, VoucherDetailsListener {
    var router: GiftApplyRouting? { get set }
    var listener: GiftApplyListener? { get set }
}

protocol GiftApplyViewControllable: ViewControllable {
}

final class GiftApplyRouter: ViewableRouter<GiftApplyInteractable, GiftApplyViewControllable> {

    private var voucherDetailsRouter: VoucherDetailsRouting?
    private var voucherDetailsBuilder: VoucherDetailsBuildable

    init(interactor: GiftApplyInteractable,
         viewController: GiftApplyViewControllable,
         voucherDetailsBuilder: VoucherDetailsBuildable) {
        self.voucherDetailsBuilder = voucherDetailsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

extension GiftApplyRouter: GiftApplyRouting {
    func routeToVoucherDetails(voucher: Voucher) {
        guard self.voucherDetailsRouter == nil else {
            return
        }

        let router = self.voucherDetailsBuilder.build(withListener: self.interactor, voucher: voucher, isFromGift: false)
        self.attachChild(router)
        self.viewControllable.push(viewControllable: router.viewControllable)
        self.voucherDetailsRouter = router
    }

    func dismissVoucherDetails(animated: Bool) {
        guard let router = self.voucherDetailsRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.popToBefore(viewControllable: router.viewControllable, animated: animated)
        self.voucherDetailsRouter = nil
    }
}
