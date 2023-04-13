//
//  EditProfileBuilder.swift
//  E-Wallet
//
//  Created by đào sơn on 12/04/2023.
//

import RIBs

protocol EditProfileDependency: Dependency {

}

final class EditProfileComponent: Component<EditProfileDependency> {
}

// MARK: - Builder

protocol EditProfileBuildable: Buildable {
    func build(withListener listener: EditProfileListener, userEntity: UserEntity) -> EditProfileRouting
}

final class EditProfileBuilder: Builder<EditProfileDependency>, EditProfileBuildable {

    override init(dependency: EditProfileDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EditProfileListener, userEntity: UserEntity) -> EditProfileRouting {
        let component = EditProfileComponent(dependency: dependency)
        let viewController = EditProfileViewController()
        let interactor = EditProfileInteractor(presenter: viewController, userEntity: userEntity)
        interactor.listener = listener
        return EditProfileRouter(interactor: interactor, viewController: viewController)
    }
}
