//
//  ProfileBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import RIBs

protocol ProfileDependency: Dependency {

}

final class ProfileComponent: Component<ProfileDependency> {
}

// MARK: - Builder

protocol ProfileBuildable: Buildable {
    func build(withListener listener: ProfileListener) -> ProfileRouting
}

final class ProfileBuilder: Builder<ProfileDependency>, ProfileBuildable {

    override init(dependency: ProfileDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileListener) -> ProfileRouting {
        let component = ProfileComponent(dependency: dependency)
        let viewController = ProfileViewController()
        let interactor = ProfileInteractor(presenter: viewController)
        interactor.listener = listener
        let editProfileBuilder = DIContainer.resolve(EditProfileBuildable.self, agrument: component)
        let enterPasswordBuilder = DIContainer.resolve(EnterPasswordBuildable.self, agrument: component)
        let expenseBuilder = DIContainer.resolve(ExpenseBuildable.self, agrument: component)
        return ProfileRouter(interactor: interactor,
                             viewController: viewController,
                             editProfileBuilder: editProfileBuilder,
                             enterPasswordBuilder: enterPasswordBuilder,
                             expenseBuilder: expenseBuilder)
    }
}
