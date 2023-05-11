//
//  SignInRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 05/04/2023.
//

import RIBs

protocol SignInInteractable: Interactable, VerifyCodeListener, EnterPasswordListener, FillProfileListener {
    var router: SignInRouting? { get set }
    var listener: SignInListener? { get set }
}

protocol SignInViewControllable: ViewControllable {
}

final class SignInRouter: ViewableRouter<SignInInteractable, SignInViewControllable> {
    private var verifyCodeRouter: VerifyCodeRouting?
    private var verifyCodeBuilder: VerifyCodeBuildable

    private var enterPasswordRouter: EnterPasswordRouting?
    private var enterPasswordBuilder: EnterPasswordBuildable

    private var fillProfileRouter: FillProfileRouting?
    private var fillProfileBuilder: FillProfileBuildable

    init(interactor: SignInInteractable,
         viewController: SignInViewControllable,
         verifyCodeBuilder: VerifyCodeBuildable,
         enterPasswordBuilder: EnterPasswordBuildable,
         fillProfileBuilder: FillProfileBuildable) {
        self.verifyCodeBuilder = verifyCodeBuilder
        self.enterPasswordBuilder = enterPasswordBuilder
        self.fillProfileBuilder = fillProfileBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - SignInRouting
extension SignInRouter: SignInRouting {
    func routeToVerifyCode(verificationID: String, phoneNumber: String) {
        guard self.verifyCodeRouter == nil else {
            return
        }

        let router = self.verifyCodeBuilder.build(withListener: self.interactor, verificationID: verificationID, phoneNumber: phoneNumber)
        self.viewControllable.push(viewControllable: router.viewControllable, animated: true)
        self.attachChild(router)
        self.verifyCodeRouter = router
    }

    func dismissVerifyCode() {
        guard let router = self.verifyCodeRouter else {
            return
        }

        detachChild(router)
        self.viewController.popToBefore(viewControllable: router.viewControllable)
        self.verifyCodeRouter = nil
    }

    func routeToEnterPassword(isNewUser: Bool, isConfirmPassword: Bool, password: String) {
        guard self.enterPasswordRouter == nil else {
            return
        }

        let router = self.enterPasswordBuilder.build(withListener: self.interactor,
                                                     isNewUser: isNewUser,
                                                     isConfirmPassword: isConfirmPassword,
                                                     password: password,
                                                     isForceToEnterPassword: true)
        self.viewController.uiviewController.presentCustomViewController(router.viewControllable.uiviewController)
        self.attachChild(router)
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

    func routeToFillProfile() {
        guard self.fillProfileRouter == nil else {
            return
        }

        let router = self.fillProfileBuilder.build(withListener: self.interactor)
        self.viewControllable.push(viewControllable: router.viewControllable, animated: true)
        self.attachChild(router)
        self.fillProfileRouter = router
    }

    func dismissFillProfile() {
        guard let router = self.fillProfileRouter else {
            return
        }

        detachChild(router)
        self.viewController.popToBefore(viewControllable: router.viewControllable)
        self.fillProfileRouter = nil
    }

    func bindSignUpResultToFillProfile(isSuccess: Bool) {
        self.fillProfileRouter?.bindSignUpResult(isSuccess: isSuccess)
    }
}
