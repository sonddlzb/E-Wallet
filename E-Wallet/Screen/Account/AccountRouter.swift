//
//  AccountRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import RIBs

protocol AccountInteractable: Interactable, CardDetailsListener {
    var router: AccountRouting? { get set }
    var listener: AccountListener? { get set }

    func reloadData()
}

protocol AccountViewControllable: ViewControllable {
}

final class AccountRouter: ViewableRouter<AccountInteractable, AccountViewControllable> {
    private var cardDetailsRouter: CardDetailsRouting?
    private var cardDetailsBuilder: CardDetailsBuildable

    init(interactor: AccountInteractable,
         viewController: AccountViewControllable,
         cardDetailsBuilder: CardDetailsBuildable) {
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

    func reloadData() {
        self.interactor.reloadData()
    }
}
