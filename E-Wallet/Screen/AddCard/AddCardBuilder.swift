//
//  AddCardBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import RIBs

protocol AddCardDependency: Dependency {

}

final class AddCardComponent: Component<AddCardDependency> {
}

// MARK: - Builder

protocol AddCardBuildable: Buildable {
    func build(withListener listener: AddCardListener) -> AddCardRouting
}

final class AddCardBuilder: Builder<AddCardDependency>, AddCardBuildable {

    override init(dependency: AddCardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddCardListener) -> AddCardRouting {
        let component = AddCardComponent(dependency: dependency)
        let viewController = AddCardViewController()
        let interactor = AddCardInteractor(presenter: viewController)
        interactor.listener = listener
        return AddCardRouter(interactor: interactor, viewController: viewController)
    }
}
