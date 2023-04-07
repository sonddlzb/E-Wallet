//
//  EnterPasswordBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 07/04/2023.
//

import RIBs

protocol EnterPasswordDependency: Dependency {

}

final class EnterPasswordComponent: Component<EnterPasswordDependency> {
}

// MARK: - Builder

protocol EnterPasswordBuildable: Buildable {
    func build(withListener listener: EnterPasswordListener,
               isNewUser: Bool,
               isConfirmPassword: Bool,
               password: String) -> EnterPasswordRouting
}

final class EnterPasswordBuilder: Builder<EnterPasswordDependency>, EnterPasswordBuildable {

    override init(dependency: EnterPasswordDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EnterPasswordListener,
               isNewUser: Bool,
               isConfirmPassword: Bool,
               password: String) -> EnterPasswordRouting {
        let component = EnterPasswordComponent(dependency: dependency)
        let viewController = EnterPasswordViewController()
        let interactor = EnterPasswordInteractor(presenter: viewController,
                                                 isNewUser: isNewUser,
                                                 isConfirmPassword: isConfirmPassword,
                                                 password: password)
        interactor.listener = listener
        return EnterPasswordRouter(interactor: interactor, viewController: viewController)
    }
}
