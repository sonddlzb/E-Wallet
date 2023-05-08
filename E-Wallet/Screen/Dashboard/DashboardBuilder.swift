//
//  DashboardBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import RIBs

protocol DashboardDependency: Dependency {

}

final class DashboardComponent: Component<DashboardDependency> {
}

// MARK: - Builder

protocol DashboardBuildable: Buildable {
    func build(withListener listener: DashboardListener) -> DashboardRouting
}

final class DashboardBuilder: Builder<DashboardDependency>, DashboardBuildable {

    override init(dependency: DashboardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DashboardListener) -> DashboardRouting {
        let component = DashboardComponent(dependency: dependency)
        let viewController = DashboardViewController()
        let interactor = DashboardInteractor(presenter: viewController)
        interactor.listener = listener
        return DashboardRouter(interactor: interactor,
                               viewController: viewController)
    }
}
