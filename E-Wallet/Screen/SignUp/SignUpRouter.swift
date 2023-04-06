//
//  SignUpRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 06/04/2023.
//

import RIBs

protocol SignUpInteractable: Interactable, VerifyCodeListener {
    var router: SignUpRouting? { get set }
    var listener: SignUpListener? { get set }
}

protocol SignUpViewControllable: ViewControllable {
}

final class SignUpRouter: ViewableRouter<SignUpInteractable, SignUpViewControllable> {
    private var verifyCodeRouter: VerifyCodeRouting?
    private var verifyCodeBuilder: VerifyCodeBuildable

    init(interactor: SignUpInteractable,
         viewController: SignUpViewControllable,
         verifyCodeBuilder: VerifyCodeBuildable) {
        self.verifyCodeBuilder = verifyCodeBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - SignUpRouting
extension SignUpRouter: SignUpRouting {
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
}
