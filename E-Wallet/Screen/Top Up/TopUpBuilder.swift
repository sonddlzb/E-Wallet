//
//  TopUpBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 17/04/2023.
//

import RIBs

protocol TopUpDependency: Dependency {

}

final class TopUpComponent: Component<TopUpDependency> {
}

// MARK: - Builder

protocol TopUpBuildable: Buildable {
    func build(withListener listener: TopUpListener) -> TopUpRouting
}

final class TopUpBuilder: Builder<TopUpDependency>, TopUpBuildable {

    override init(dependency: TopUpDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TopUpListener) -> TopUpRouting {
        let component = TopUpComponent(dependency: dependency)
        let viewController = TopUpViewController()
        let interactor = TopUpInteractor(presenter: viewController)
        interactor.listener = listener
        return TopUpRouter(interactor: interactor, viewController: viewController)
    }
}
