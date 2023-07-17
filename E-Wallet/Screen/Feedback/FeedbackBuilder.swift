//
//  FeedbackBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 17/07/2023.
//

import RIBs

protocol FeedbackDependency: Dependency {

}

final class FeedbackComponent: Component<FeedbackDependency> {
}

// MARK: - Builder

protocol FeedbackBuildable: Buildable {
    func build(withListener listener: FeedbackListener) -> FeedbackRouting
}

final class FeedbackBuilder: Builder<FeedbackDependency>, FeedbackBuildable {

    override init(dependency: FeedbackDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FeedbackListener) -> FeedbackRouting {
        let component = FeedbackComponent(dependency: dependency)
        let viewController = FeedbackViewController()
        let interactor = FeedbackInteractor(presenter: viewController)
        interactor.listener = listener
        return FeedbackRouter(interactor: interactor, viewController: viewController)
    }
}
