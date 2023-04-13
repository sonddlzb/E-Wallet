//
//  ProfileRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import RIBs

protocol ProfileInteractable: Interactable, EditProfileListener {
    var router: ProfileRouting? { get set }
    var listener: ProfileListener? { get set }
}

protocol ProfileViewControllable: ViewControllable {
}

final class ProfileRouter: ViewableRouter<ProfileInteractable, ProfileViewControllable> {
    private var editProfileRouter: EditProfileRouting?
    private var editProfileBuilder: EditProfileBuildable

    init(interactor: ProfileInteractable,
         viewController: ProfileViewControllable,
         editProfileBuilder: EditProfileBuildable) {
        self.editProfileBuilder = editProfileBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - ProfileRouting
extension ProfileRouter: ProfileRouting {
    func routeToEditProfile(userEntity: UserEntity) {
        guard self.editProfileRouter == nil else {
            return
        }

        let router = self.editProfileBuilder.build(withListener: self.interactor, userEntity: userEntity)
        self.viewControllable.push(viewControllable: router.viewControllable, animated: true)
        self.attachChild(router)
        self.editProfileRouter = router
    }

    func dismissEditProfile() {
        guard let router = self.editProfileRouter else {
            return
        }

        detachChild(router)
        self.viewController.popToBefore(viewControllable: router.viewControllable)
        self.editProfileRouter = nil
    }
}
