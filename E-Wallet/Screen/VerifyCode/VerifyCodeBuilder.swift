//
//  VerifyCodeBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 06/04/2023.
//

import RIBs

protocol VerifyCodeDependency: Dependency {

}

final class VerifyCodeComponent: Component<VerifyCodeDependency> {
}

// MARK: - Builder

protocol VerifyCodeBuildable: Buildable {
    func build(withListener listener: VerifyCodeListener,
               verificationID: String,
               phoneNumber: String) -> VerifyCodeRouting
}

final class VerifyCodeBuilder: Builder<VerifyCodeDependency>, VerifyCodeBuildable {

    override init(dependency: VerifyCodeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: VerifyCodeListener,
               verificationID: String,
               phoneNumber: String) -> VerifyCodeRouting {
        let component = VerifyCodeComponent(dependency: dependency)
        let viewController = VerifyCodeViewController(phoneNumber: phoneNumber)
        let interactor = VerifyCodeInteractor(presenter: viewController, verificationID: verificationID)
        interactor.listener = listener
        return VerifyCodeRouter(interactor: interactor, viewController: viewController)
    }
}
