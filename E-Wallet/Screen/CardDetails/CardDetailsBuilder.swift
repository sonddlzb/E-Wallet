//
//  CardDetailsBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 16/04/2023.
//

import RIBs

protocol CardDetailsDependency: Dependency {

}

final class CardDetailsComponent: Component<CardDetailsDependency> {
}

// MARK: - Builder

protocol CardDetailsBuildable: Buildable {
    func build(withListener listener: CardDetailsListener, card: Card) -> CardDetailsRouting
}

final class CardDetailsBuilder: Builder<CardDetailsDependency>, CardDetailsBuildable {

    override init(dependency: CardDetailsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CardDetailsListener, card: Card) -> CardDetailsRouting {
        let component = CardDetailsComponent(dependency: dependency)
        let viewController = CardDetailsViewController()
        let interactor = CardDetailsInteractor(presenter: viewController, card: card)
        interactor.listener = listener
        return CardDetailsRouter(interactor: interactor, viewController: viewController)
    }
}
