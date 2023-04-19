//
//  SelectCardBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 19/04/2023.
//

import RIBs

protocol SelectCardDependency: Dependency {

}

final class SelectCardComponent: Component<SelectCardDependency> {
}

// MARK: - Builder

protocol SelectCardBuildable: Buildable {
    func build(withListener listener: SelectCardListener, selectedCard: Card?) -> SelectCardRouting
}

final class SelectCardBuilder: Builder<SelectCardDependency>, SelectCardBuildable {

    override init(dependency: SelectCardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SelectCardListener, selectedCard: Card?) -> SelectCardRouting {
        let component = SelectCardComponent(dependency: dependency)
        let viewController = SelectCardViewController()
        let interactor = SelectCardInteractor(presenter: viewController, selectedCard: selectedCard)
        interactor.listener = listener
        return SelectCardRouter(interactor: interactor, viewController: viewController)
    }
}
