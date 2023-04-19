//
//  TransactionConfirmRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import RIBs

protocol TransactionConfirmInteractable: Interactable, SelectCardListener {
    var router: TransactionConfirmRouting? { get set }
    var listener: TransactionConfirmListener? { get set }

    func reloadData()
}

protocol TransactionConfirmViewControllable: ViewControllable {
}

final class TransactionConfirmRouter: ViewableRouter<TransactionConfirmInteractable, TransactionConfirmViewControllable> {
    private var selectCardRouter: SelectCardRouting?
    private var selectCardBuilder: SelectCardBuildable

    init(interactor: TransactionConfirmInteractable,
         viewController: TransactionConfirmViewControllable,
         selectCardBuilder: SelectCardBuildable) {
        self.selectCardBuilder = selectCardBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - TransactionConfirmRouting
extension TransactionConfirmRouter: TransactionConfirmRouting {
    func showSelectCard(selectedCard: Card?) {
        guard self.selectCardRouter == nil else {
            return
        }

        let router = self.selectCardBuilder.build(withListener: interactor, selectedCard: selectedCard)
        self.attachChild(router)
        self.viewController.uiviewController.presentCustomViewController(router.viewControllable.uiviewController)
        self.selectCardRouter = router
    }

    func dismissSelectCard() {
        guard let router = self.selectCardRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.uiviewController.dismissCustomViewController()
        self.selectCardRouter = nil
    }

    func reloadData() {
        self.interactor.reloadData()
    }
}
