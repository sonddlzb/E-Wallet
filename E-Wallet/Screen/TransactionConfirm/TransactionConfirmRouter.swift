//
//  TransactionConfirmRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import RIBs

protocol TransactionConfirmInteractable: Interactable, SelectCardListener, EnterPasswordListener, ReceiptListener {
    var router: TransactionConfirmRouting? { get set }
    var listener: TransactionConfirmListener? { get set }

    func reloadData()
}

protocol TransactionConfirmViewControllable: ViewControllable {
}

final class TransactionConfirmRouter: ViewableRouter<TransactionConfirmInteractable, TransactionConfirmViewControllable> {
    private var selectCardRouter: SelectCardRouting?
    private var selectCardBuilder: SelectCardBuildable

    private var enterPasswordRouter: EnterPasswordRouting?
    private var enterPasswordBuilder: EnterPasswordBuildable

    private var receiptRouter: ReceiptRouting?
    private var receiptBuilder: ReceiptBuildable

    init(interactor: TransactionConfirmInteractable,
         viewController: TransactionConfirmViewControllable,
         selectCardBuilder: SelectCardBuildable,
         enterPasswordBuilder: EnterPasswordBuildable,
         receiptBuilder: ReceiptBuildable) {
        self.selectCardBuilder = selectCardBuilder
        self.enterPasswordBuilder = enterPasswordBuilder
        self.receiptBuilder = receiptBuilder
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

    func presentPassword() {
        guard self.enterPasswordRouter == nil else {
            return
        }

        let router = self.enterPasswordBuilder.build(withListener: interactor, isNewUser: false, isConfirmPassword: false, password: "")
        self.attachChild(router)
        self.viewController.uiviewController.presentCustomViewController(router.viewControllable.uiviewController)
        self.enterPasswordRouter = router
    }

    func dismissPassword() {
        guard let router = self.enterPasswordRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.uiviewController.dismissCustomViewController()
        self.enterPasswordRouter = nil
    }

    func bindAuthenticationResultToEnterPassword(isSuccess: Bool) {
        self.enterPasswordRouter?.bindSignInResult(isSuccess: isSuccess)
    }

    func routeToReceipt(transaction: Transaction) {
        guard self.receiptRouter == nil else {
            return
        }

        let router = self.receiptBuilder.build(withListener: interactor,
                                               transaction: transaction)
        self.attachChild(router)
        self.viewController.push(viewControllable: router.viewControllable)
        self.receiptRouter = router
    }

    func dismissReceipt(animated: Bool) {
        guard let router = self.receiptRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.popToBefore(viewControllable: router.viewControllable, animated: animated)
        self.receiptRouter = nil
    }
}
