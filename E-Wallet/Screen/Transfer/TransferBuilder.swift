//
//  TransferBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 13/04/2023.
//

import RIBs

protocol TransferDependency: Dependency {

}

final class TransferComponent: Component<TransferDependency> {
}

// MARK: - Builder

protocol TransferBuildable: Buildable {
    func build(withListener listener: TransferListener, phoneNumber: String?) -> TransferRouting
}

final class TransferBuilder: Builder<TransferDependency>, TransferBuildable {

    override init(dependency: TransferDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TransferListener, phoneNumber: String?) -> TransferRouting {
        let component = TransferComponent(dependency: dependency)
        let viewController = TransferViewController()
        let interactor = TransferInteractor(presenter: viewController, phoneNumber: phoneNumber)
        interactor.listener = listener
        return TransferRouter(interactor: interactor,
                              viewController: viewController)
    }
}
