//
//  AccountBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import RIBs

protocol AccountDependency: Dependency {

}

final class AccountComponent: Component<AccountDependency> {
}

// MARK: - Builder

protocol AccountBuildable: Buildable {
    func build(withListener listener: AccountListener) -> AccountRouting
}

final class AccountBuilder: Builder<AccountDependency>, AccountBuildable {

    override init(dependency: AccountDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AccountListener) -> AccountRouting {
        let component = AccountComponent(dependency: dependency)
        let viewController = AccountViewController()
        let interactor = AccountInteractor(presenter: viewController)
        interactor.listener = listener
        let cardDetailsBuilder = DIContainer.resolve(CardDetailsBuildable.self, agrument: component)
        return AccountRouter(interactor: interactor,
                             viewController: viewController,
                             cardDetailsBuilder: cardDetailsBuilder)
    }
}
