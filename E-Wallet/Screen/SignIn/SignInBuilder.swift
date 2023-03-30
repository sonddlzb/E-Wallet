//
//  SignInBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 05/04/2023.
//

import RIBs

protocol SignInDependency: Dependency {

}

final class SignInComponent: Component<SignInDependency> {
}

// MARK: - Builder

protocol SignInBuildable: Buildable {
    func build(withListener listener: SignInListener) -> SignInRouting
}

final class SignInBuilder: Builder<SignInDependency>, SignInBuildable {

    override init(dependency: SignInDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SignInListener) -> SignInRouting {
        let component = SignInComponent(dependency: dependency)
        let viewController = SignInViewController()
        let interactor = SignInInteractor(presenter: viewController)
        interactor.listener = listener
        return SignInRouter(interactor: interactor, viewController: viewController)
    }
}
