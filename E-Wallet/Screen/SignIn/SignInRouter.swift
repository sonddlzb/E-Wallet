//
//  SignInRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 05/04/2023.
//

import RIBs

protocol SignInInteractable: Interactable, VerifyCodeListener, EnterPasswordListener {
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

    init(interactor: SignInInteractable,
         viewController: SignInViewControllable,
         verifyCodeBuilder: VerifyCodeBuildable,
         enterPasswordBuilder: EnterPasswordBuildable) {
        self.verifyCodeBuilder = verifyCodeBuilder
        self.enterPasswordBuilder = enterPasswordBuilder
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
                                                     password: password)
        router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
        self.viewControllable.present(viewControllable: router.viewControllable, animated: true)
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

    func bindSignInResultToEnterPassword(isSuccess: Bool) {
        self.enterPasswordRouter?.bindSignInResult(isSuccess: isSuccess)
    }
}
