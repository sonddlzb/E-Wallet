//
//  WithdrawBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import RIBs

protocol WithdrawDependency: Dependency {

}

final class WithdrawComponent: Component<WithdrawDependency> {
}

// MARK: - Builder

protocol WithdrawBuildable: Buildable {
    func build(withListener listener: WithdrawListener) -> WithdrawRouting
}

final class WithdrawBuilder: Builder<WithdrawDependency>, WithdrawBuildable {

    override init(dependency: WithdrawDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: WithdrawListener) -> WithdrawRouting {
        let component = WithdrawComponent(dependency: dependency)
        let viewController = WithdrawViewController()
        let interactor = WithdrawInteractor(presenter: viewController)
        interactor.listener = listener
        return WithdrawRouter(interactor: interactor, viewController: viewController)
    }
}
