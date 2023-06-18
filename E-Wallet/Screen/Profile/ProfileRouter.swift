//
//  ProfileRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import RIBs

protocol ProfileInteractable: Interactable, EditProfileListener, EnterPasswordListener, ExpenseListener, AccountListener {
    var router: ProfileRouting? { get set }
    var listener: ProfileListener? { get set }

    func bind(homeViewModel: HomeViewModel)
}

protocol ProfileViewControllable: ViewControllable {
}

final class ProfileRouter: ViewableRouter<ProfileInteractable, ProfileViewControllable> {
    private var editProfileRouter: EditProfileRouting?
    private var editProfileBuilder: EditProfileBuildable

    private var enterPasswordRouter: EnterPasswordRouting?
    private var enterPasswordBuilder: EnterPasswordBuildable

    private var expenseRouter: ExpenseRouting?
    private var expenseBuilder: ExpenseBuildable

    private var accountRouter: AccountRouting?
    private var accountBuilder: AccountBuildable

    init(interactor: ProfileInteractable,
         viewController: ProfileViewControllable,
         editProfileBuilder: EditProfileBuildable,
         enterPasswordBuilder: EnterPasswordBuildable,
         expenseBuilder: ExpenseBuildable,
         accountBuilder: AccountBuildable) {
        self.enterPasswordBuilder = enterPasswordBuilder
        self.editProfileBuilder = editProfileBuilder
        self.expenseBuilder = expenseBuilder
        self.accountBuilder = accountBuilder
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

    func bind(homeViewModel: HomeViewModel) {
        self.interactor.bind(homeViewModel: homeViewModel)
    }

    func routeToEnterPassword(isNewUser: Bool, isConfirmPassword: Bool, password: String) {
        guard self.enterPasswordRouter == nil else {
            return
        }

        let router = self.enterPasswordBuilder.build(withListener: self.interactor,
                                                     isNewUser: isNewUser,
                                                     isConfirmPassword: isConfirmPassword,
                                                     password: password,
                                                     isForceToEnterPassword: false)
        self.viewControllable.uiviewController.presentCustomViewController(router.viewControllable.uiviewController)
        self.enterPasswordRouter = router
    }

    func dismissEnterPassword() {
        guard let router = self.enterPasswordRouter else {
            return
        }

        detachChild(router)
        self.viewController.dismiss()
        self.enterPasswordRouter = nil
    }

    func bindAuthenticationResultToEnterPassword(isSuccess: Bool) {
        self.enterPasswordRouter?.bindSignInResult(isSuccess: isSuccess)
    }

    func routeToExpense() {
        guard self.expenseRouter == nil else {
            return
        }

        let router = self.expenseBuilder.build(withListener: self.interactor)
        self.viewControllable.push(viewControllable: router.viewControllable, animated: true)
        self.attachChild(router)
        self.expenseRouter = router
    }

    func dismissExpense() {
        guard let router = self.expenseRouter else {
            return
        }

        detachChild(router)
        self.viewController.popToBefore(viewControllable: router.viewControllable)
        self.expenseRouter = nil
    }

    func routeToAccount() {
        guard self.accountRouter == nil else {
            return
        }

        let router = self.accountBuilder.build(withListener: self.interactor)
        self.attachChild(router)
        self.viewControllable.push(viewControllable: router.viewControllable)
        self.accountRouter = router
    }

    func dismissAccount() {
        guard let router = self.accountRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.popToBefore(viewControllable: router.viewControllable)
        self.accountRouter = nil
    }

    func reloadCardData() {
        self.accountRouter?.reloadData()
    }
}
