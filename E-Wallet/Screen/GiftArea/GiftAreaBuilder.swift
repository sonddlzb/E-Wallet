//
//  GiftAreaBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 18/07/2023.
//

import RIBs

protocol GiftAreaDependency: Dependency {

}

final class GiftAreaComponent: Component<GiftAreaDependency> {
}

// MARK: - Builder

protocol GiftAreaBuildable: Buildable {
    func build(withListener listener: GiftAreaListener, voucher: Voucher) -> GiftAreaRouting
}

final class GiftAreaBuilder: Builder<GiftAreaDependency>, GiftAreaBuildable {

    override init(dependency: GiftAreaDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: GiftAreaListener, voucher: Voucher) -> GiftAreaRouting {
        let component = GiftAreaComponent(dependency: dependency)
        let viewController = GiftAreaViewController()
        let interactor = GiftAreaInteractor(presenter: viewController, voucher: voucher)
        interactor.listener = listener
        return GiftAreaRouter(interactor: interactor, viewController: viewController)
    }
}
