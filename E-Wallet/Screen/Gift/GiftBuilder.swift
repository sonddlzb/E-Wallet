//
//  GiftBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 04/05/2023.
//

import RIBs

protocol GiftDependency: Dependency {

}

final class GiftComponent: Component<GiftDependency> {
}

// MARK: - Builder

protocol GiftBuildable: Buildable {
    func build(withListener listener: GiftListener) -> GiftRouting
}

final class GiftBuilder: Builder<GiftDependency>, GiftBuildable {

    override init(dependency: GiftDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: GiftListener) -> GiftRouting {
        let component = GiftComponent(dependency: dependency)
        let viewController = GiftViewController()
        let interactor = GiftInteractor(presenter: viewController)
        interactor.listener = listener
        let voucherDetailsBuilder = DIContainer.resolve(VoucherDetailsBuildable.self, agrument: component)
        let giftAreaBuilder = DIContainer.resolve(GiftAreaBuildable.self, agrument: component)
        return GiftRouter(interactor: interactor,
                          viewController: viewController,
                          voucherDetailsBuilder: voucherDetailsBuilder,
                          giftAreaBuilder: giftAreaBuilder)
    }
}
