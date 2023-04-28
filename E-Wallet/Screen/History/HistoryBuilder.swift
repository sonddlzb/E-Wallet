//
//  HistoryBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 25/04/2023.
//

import RIBs

protocol HistoryDependency: Dependency {

}

final class HistoryComponent: Component<HistoryDependency> {
}

// MARK: - Builder

protocol HistoryBuildable: Buildable {
    func build(withListener listener: HistoryListener) -> HistoryRouting
}

final class HistoryBuilder: Builder<HistoryDependency>, HistoryBuildable {

    override init(dependency: HistoryDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: HistoryListener) -> HistoryRouting {
        let component = HistoryComponent(dependency: dependency)
        let viewController = HistoryViewController()
        let interactor = HistoryInteractor(presenter: viewController)
        interactor.listener = listener
        let transactionDetailsBuilder = DIContainer.resolve(TransactionDetailsBuildable.self, agrument: component)
        return HistoryRouter(interactor: interactor,
                             viewController: viewController,
                             transactionDetailsBuilder: transactionDetailsBuilder)
    }
}
