//
//  AccountRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import RIBs

protocol AccountInteractable: Interactable, AddCardListener, CardDetailsListener {
    var router: AccountRouting? { get set }
    var listener: AccountListener? { get set }
}

protocol AccountViewControllable: ViewControllable {
}

final class AccountRouter: ViewableRouter<AccountInteractable, AccountViewControllable> {
    private var addCardRouter: AddCardRouting?
    private var addCardBuilder: AddCardBuildable

    private var cardDetailsRouter: CardDetailsRouting?
    private var cardDetailsBuilder: CardDetailsBuildable

    init(interactor: AccountInteractable,
         viewController: AccountViewControllable,
         addCardBuilder: AddCardBuildable,
         cardDetailsBuilder: CardDetailsBuildable) {
        self.addCardBuilder = addCardBuilder
        self.cardDetailsBuilder = cardDetailsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - AccountRouting
extension AccountRouter: AccountRouting {
    func routeToCardDetails(_ card: Card) {
        guard self.cardDetailsRouter == nil else {
            return
        }

        let router = self.cardDetailsBuilder.build(withListener: interactor, card: card)
        self.attachChild(router)
        self.viewController.push(viewControllable: router.viewControllable, animated: true)
        self.cardDetailsRouter = router
    }

    func dismissCardDetails() {
        guard let router = self.cardDetailsRouter else {
            return
        }

        self.detachChild(router)
        self.viewController.popToBefore(viewControllable: router.viewControllable)
        self.cardDetailsRouter = nil
    }

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
