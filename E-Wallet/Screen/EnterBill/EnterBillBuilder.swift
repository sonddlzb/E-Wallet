//
//  EnterBillBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 05/05/2023.
//

import RIBs

protocol EnterBillDependency: Dependency {

}

final class EnterBillComponent: Component<EnterBillDependency> {
}

// MARK: - Builder

protocol EnterBillBuildable: Buildable {
    func build(withListener listener: EnterBillListener, serviceType: ServiceType) -> EnterBillRouting
}

final class EnterBillBuilder: Builder<EnterBillDependency>, EnterBillBuildable {

    override init(dependency: EnterBillDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EnterBillListener, serviceType: ServiceType) -> EnterBillRouting {
        let component = EnterBillComponent(dependency: dependency)
        let viewController = EnterBillViewController()
        let interactor = EnterBillInteractor(presenter: viewController, serviceType: serviceType)
        interactor.listener = listener
        return EnterBillRouter(interactor: interactor, viewController: viewController)
    }
}
