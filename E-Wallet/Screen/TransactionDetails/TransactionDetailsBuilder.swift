//
//  TransactionDetailsBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 27/04/2023.
//

import RIBs

protocol TransactionDetailsDependency: Dependency {

}

final class TransactionDetailsComponent: Component<TransactionDetailsDependency> {
}

// MARK: - Builder

protocol TransactionDetailsBuildable: Buildable {
    func build(withListener listener: TransactionDetailsListener, transaction: Transaction) -> TransactionDetailsRouting
}

final class TransactionDetailsBuilder: Builder<TransactionDetailsDependency>, TransactionDetailsBuildable {

    override init(dependency: TransactionDetailsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TransactionDetailsListener, transaction: Transaction) -> TransactionDetailsRouting {
        let component = TransactionDetailsComponent(dependency: dependency)
        let viewController = TransactionDetailsViewController()
        let interactor = TransactionDetailsInteractor(presenter: viewController, transaction: transaction)
        interactor.listener = listener
        return TransactionDetailsRouter(interactor: interactor, viewController: viewController)
    }
}
