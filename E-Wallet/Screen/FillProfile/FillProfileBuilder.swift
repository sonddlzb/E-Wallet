//
//  FillProfileBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 07/04/2023.
//

import RIBs

protocol FillProfileDependency: Dependency {

}

final class FillProfileComponent: Component<FillProfileDependency> {
}

// MARK: - Builder

protocol FillProfileBuildable: Buildable {
    func build(withListener listener: FillProfileListener) -> FillProfileRouting
}

final class FillProfileBuilder: Builder<FillProfileDependency>, FillProfileBuildable {

    override init(dependency: FillProfileDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FillProfileListener) -> FillProfileRouting {
        let component = FillProfileComponent(dependency: dependency)
        let viewController = FillProfileViewController()
        let interactor = FillProfileInteractor(presenter: viewController)
        interactor.listener = listener
        return FillProfileRouter(interactor: interactor, viewController: viewController)
    }
}
