//
//  IntroductionBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import RIBs

protocol IntroductionDependency: Dependency {

}

final class IntroductionComponent: Component<IntroductionDependency> {
}

// MARK: - Builder

protocol IntroductionBuildable: Buildable {
    func build(withListener listener: IntroductionListener) -> IntroductionRouting
}

final class IntroductionBuilder: Builder<IntroductionDependency>, IntroductionBuildable {

    override init(dependency: IntroductionDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: IntroductionListener) -> IntroductionRouting {
        let component = IntroductionComponent(dependency: dependency)
        let viewController = IntroductionViewController()
        let interactor = IntroductionInteractor(presenter: viewController)
        interactor.listener = listener
        return IntroductionRouter(interactor: interactor, viewController: viewController)
    }
}
