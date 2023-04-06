//
//  RootRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 30/03/2023.
//

import RIBs

protocol RootInteractable: Interactable, SignInListener, SplashListener, SignUpListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
}

final class RootRouter: ViewableRouter<RootInteractable, RootViewControllable> {
    var window: UIWindow

    private var signInRouter: SignInRouting?
    private var signInBuilder: SignInBuildable

    private var splashRouter: SplashRouting?
    private var splashBuilder: SplashBuildable

    private var signUpRouter: SignUpRouting?
    private var signUpBuilder: SignUpBuildable

    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         window: UIWindow,
         signInBuilder: SignInBuildable,
         splashBuilder: SplashBuildable,
         signUpBuilder: SignUpBuildable) {
        self.window = window
        self.signInBuilder = signInBuilder
        self.splashBuilder = splashBuilder
        self.signUpBuilder = signUpBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - RootRouting
extension RootRouter: RootRouting {
    func routeToSignIn() {
        let router = self.signInBuilder.build(withListener: self.interactor)
        let navigationController = BaseNavigationController(rootViewController: router.viewControllable.uiviewController)
        window.rootViewController = navigationController
        attachChild(router)
        self.signInRouter = router
    }

    func routeToSplash() {
        let router = self.splashBuilder.build(withListener: self.interactor)
        let navigationController = BaseNavigationController(rootViewController: router.viewControllable.uiviewController)
        window.rootViewController = navigationController
        attachChild(router)
        self.splashRouter = router
    }

    func dismissSplash() {
        guard let router = self.splashRouter else {
            return
        }

        detachChild(router)
        self.splashRouter = nil
    }

    func routeToSignUp() {
        let router = self.signUpBuilder.build(withListener: self.interactor)
        let navigationController = BaseNavigationController(rootViewController: router.viewControllable.uiviewController)
        window.rootViewController = navigationController
        attachChild(router)
        self.signUpRouter = router
    }

    func dismissSignIn() {
        guard let router = self.signInRouter else {
            return
        }

        detachChild(router)
        self.signInRouter = nil
    }

    func dismissSignUp() {
        guard let router = self.signUpRouter else {
            return
        }

        detachChild(router)
        self.signUpRouter = nil
    }
}
