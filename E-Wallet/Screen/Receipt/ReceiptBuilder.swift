//
//  ReceiptBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 21/04/2023.
//

import RIBs

protocol ReceiptDependency: Dependency {

}

final class ReceiptComponent: Component<ReceiptDependency> {
}

// MARK: - Builder

protocol ReceiptBuildable: Buildable {
    func build(withListener listener: ReceiptListener, transaction: Transaction) -> ReceiptRouting
}

final class ReceiptBuilder: Builder<ReceiptDependency>, ReceiptBuildable {

    override init(dependency: ReceiptDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ReceiptListener, transaction: Transaction) -> ReceiptRouting {
        let component = ReceiptComponent(dependency: dependency)
        let viewController = ReceiptViewController()
        let interactor = ReceiptInteractor(presenter: viewController, transaction: transaction)
        interactor.listener = listener
        return ReceiptRouter(interactor: interactor, viewController: viewController)
    }
}
