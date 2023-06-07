//
//  NotificationsBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 30/05/2023.
//

import RIBs

protocol NotificationsDependency: Dependency {

}

final class NotificationsComponent: Component<NotificationsDependency> {
}

// MARK: - Builder

protocol NotificationsBuildable: Buildable {
    func build(withListener listener: NotificationsListener) -> NotificationsRouting
}

final class NotificationsBuilder: Builder<NotificationsDependency>, NotificationsBuildable {

    override init(dependency: NotificationsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: NotificationsListener) -> NotificationsRouting {
        let component = NotificationsComponent(dependency: dependency)
        let viewController = NotificationsViewController()
        let interactor = NotificationsInteractor(presenter: viewController)
        interactor.listener = listener
        let transactionDetailsBuilder = DIContainer.resolve(TransactionDetailsBuildable.self, agrument: component)
        return NotificationsRouter(interactor: interactor,
                                   viewController: viewController,
                                   transactionDetailsBuilder: transactionDetailsBuilder)
    }
}
