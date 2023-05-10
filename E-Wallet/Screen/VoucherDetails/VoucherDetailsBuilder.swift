//
//  VoucherDetailsBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 05/05/2023.
//

import RIBs

protocol VoucherDetailsDependency: Dependency {

}

final class VoucherDetailsComponent: Component<VoucherDetailsDependency> {
}

// MARK: - Builder

protocol VoucherDetailsBuildable: Buildable {
    func build(withListener listener: VoucherDetailsListener, voucher: Voucher, isFromGift: Bool) -> VoucherDetailsRouting
}

final class VoucherDetailsBuilder: Builder<VoucherDetailsDependency>, VoucherDetailsBuildable {

    override init(dependency: VoucherDetailsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: VoucherDetailsListener, voucher: Voucher, isFromGift: Bool) -> VoucherDetailsRouting {
        let component = VoucherDetailsComponent(dependency: dependency)
        let viewController = VoucherDetailsViewController()
        let interactor = VoucherDetailsInteractor(presenter: viewController, voucher: voucher, isFromGift: isFromGift)
        interactor.listener = listener
        return VoucherDetailsRouter(interactor: interactor, viewController: viewController)
    }
}
