//
//  GiftApplyBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 09/05/2023.
//

import RIBs

protocol GiftApplyDependency: Dependency {

}

final class GiftApplyComponent: Component<GiftApplyDependency> {
}

// MARK: - Builder

protocol GiftApplyBuildable: Buildable {
    func build(withListener listener: GiftApplyListener, paymentType: PaymentType, amount: Double) -> GiftApplyRouting
}

final class GiftApplyBuilder: Builder<GiftApplyDependency>, GiftApplyBuildable {

    override init(dependency: GiftApplyDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: GiftApplyListener, paymentType: PaymentType, amount: Double) -> GiftApplyRouting {
        let component = GiftApplyComponent(dependency: dependency)
        let viewController = GiftApplyViewController()
        let interactor = GiftApplyInteractor(presenter: viewController, paymentType: paymentType, amount: amount)
        interactor.listener = listener
        let voucherDetailsBuilder = DIContainer.resolve(VoucherDetailsBuildable.self, agrument: component)
        return GiftApplyRouter(interactor: interactor,
                               viewController: viewController,
                               voucherDetailsBuilder: voucherDetailsBuilder)
    }
}
