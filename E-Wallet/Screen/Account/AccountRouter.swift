//
//  AccountRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import RIBs

protocol AccountInteractable: Interactable, AddCardListener {
    var router: AccountRouting? { get set }
    var listener: AccountListener? { get set }
}

protocol AccountViewControllable: ViewControllable {
}

final class AccountRouter: ViewableRouter<AccountInteractable, AccountViewControllable> {
    private var addCardRouter: AddCardRouting?
    private var addCardBuilder: AddCardBuildable

    init(interactor: AccountInteractable,
                  viewController: AccountViewControllable,
                  addCardBuilder: AddCardBuildable) {
        self.addCardBuilder = addCardBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - AccountRouting
extension AccountRouter: AccountRouting {
    func routeToAddCard() {
        guard self.addCardRouter == nil else {
            return
        }

        let router = self.addCardBuilder.build(withListener: interactor)
        self.attachChild(router)
        self.viewController.push(viewControllable: router.viewControllable, animated: true)
        self.addCardRouter = router
    }

    func dismissAddCard() {
        guard let router = self.addCardRouter else {
            return
        }

        self.detachChild(router)
        self.viewController.popToBefore(viewControllable: router.viewControllable)
        self.addCardRouter = nil
    }
}
