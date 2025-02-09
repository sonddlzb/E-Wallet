//
//  HomeRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import RIBs

protocol HomeInteractable: Interactable, DashboardListener, ProfileListener, TransferListener, TopUpListener, AddCardListener, WithdrawListener, TransactionConfirmListener, HistoryListener, GiftListener, EnterBillListener, QRListener, ChatListener, ChatDetailsListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    func embedViewController(_ viewControlller: ViewControllable)
    func highlightOnTabBar(tab: HomeTab)
    func routeToDashboard()
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable> {

    var currentTab: HomeTab = .dashboard
    private var homeViewModel: HomeViewModel?

    private var dashboardRouter: DashboardRouting?
    private var dashboardBuilder: DashboardBuildable

    private var profileRouter: ProfileRouting?
    private var profileBuilder: ProfileBuildable

    private var transferRouter: TransferRouting?
    private var transferBuilder: TransferBuildable

    private var topUpRouter: TopUpRouting?
    private var topUpBuilder: TopUpBuildable

    private var addCardRouter: AddCardRouting?
    private var addCardBuilder: AddCardBuildable

    private var withdrawRouter: WithdrawRouting?
    private var withdrawBuilder: WithdrawBuildable

    private var transactionConfirmRouter: TransactionConfirmRouting?
    private var transactionConfirmBuilder: TransactionConfirmBuildable

    private var historyRouter: HistoryRouting?
    private var historyBuilder: HistoryBuildable

    private var giftRouter: GiftRouting?
    private var giftBuilder: GiftBuildable

    private var enterBillRouter: EnterBillRouting?
    private var enterBillBuilder: EnterBillBuildable

    private var qrRouter: QRRouting?
    private var qrBuilder: QRBuildable

    private var chatRouter: ChatRouting?
    private var chatBuilder: ChatBuildable

    private var chatDetailsRouter: ChatDetailsRouting?
    private var chatDetailsBuilder: ChatDetailsBuildable

    init(interactor: HomeInteractable,
         viewController: HomeViewControllable,
         dashboardBuilder: DashboardBuildable,
         profileBuilder: ProfileBuildable,
         transferBuilder: TransferBuildable,
         topUpBuilder: TopUpBuildable,
         addCardBuilder: AddCardBuildable,
         withdrawBuilder: WithdrawBuildable,
         transactionConfirmBuilder: TransactionConfirmBuildable,
         historyBuilder: HistoryBuildable,
         giftBuilder: GiftBuildable,
         enterBillBuilder: EnterBillBuildable,
         qrBuilder: QRBuildable,
         chatBuilder: ChatBuildable,
         chatDetailsBuilder: ChatDetailsBuildable) {
        self.dashboardBuilder = dashboardBuilder
        self.profileBuilder = profileBuilder
        self.transferBuilder = transferBuilder
        self.topUpBuilder = topUpBuilder
        self.addCardBuilder = addCardBuilder
        self.withdrawBuilder = withdrawBuilder
        self.transactionConfirmBuilder = transactionConfirmBuilder
        self.historyBuilder = historyBuilder
        self.giftBuilder = giftBuilder
        self.enterBillBuilder = enterBillBuilder
        self.qrBuilder = qrBuilder
        self.chatBuilder = chatBuilder
        self.chatDetailsBuilder = chatDetailsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - HomeRouting
extension HomeRouter: HomeRouting {
    func getCurrentTabType() -> HomeTab {
        return self.currentTab
    }

    func dashboardWantToReloadData() {
        // reload dashboard
    }

    func routeToTab(homeTab: HomeTab) {
        self.viewController.highlightOnTabBar(tab: homeTab)
        switch homeTab {
        case .dashboard:
            self.routeToDashboardTab()
        case .gift:
            self.routeToGiftTab()
        case .history:
            self.routeToHistoryTab()
        case .chat:
            self.routeToChatTab()
        case .myProfile:
            self.routeToProfileTab()
        }

        self.currentTab = homeTab
    }

    func routeToDashboardTab() {
        if self.dashboardRouter == nil {
            self.dashboardRouter = self.dashboardBuilder.build(withListener: self.interactor)
            attachChild(self.dashboardRouter!)
        }

        self.viewController.embedViewController(self.dashboardRouter!.viewControllable)
    }

    func routeToGiftTab() {
        if self.giftRouter == nil {
            self.giftRouter = self.giftBuilder.build(withListener: self.interactor)
            attachChild(self.giftRouter!)
        }

        self.viewController.embedViewController(self.giftRouter!.viewControllable)
    }

    func routeToHistoryTab() {
        if self.historyRouter == nil {
            self.historyRouter = self.historyBuilder.build(withListener: self.interactor)
            attachChild(self.historyRouter!)
        }

        self.viewController.embedViewController(self.historyRouter!.viewControllable)
    }

    func routeToProfileTab() {
        if self.profileRouter == nil {
            self.profileRouter = self.profileBuilder.build(withListener: self.interactor)
            attachChild(self.profileRouter!)
            if let viewModel = self.homeViewModel {
                self.profileRouter?.bind(homeViewModel: viewModel)
            }
        }

        self.viewController.embedViewController(self.profileRouter!.viewControllable)
    }

    func bindDataToHomeTab(viewModel: HomeViewModel) {
        self.homeViewModel = viewModel
        self.dashboardRouter?.bind(homeViewModel: viewModel)
        self.profileRouter?.bind(homeViewModel: viewModel)
        self.withdrawRouter?.bind(homeViewModel: viewModel)
    }

    func routeToTransfer(phoneNumber: String?) {
        guard self.transferRouter == nil else {
            return
        }

        let router = self.transferBuilder.build(withListener: self.interactor, phoneNumber: phoneNumber)
        self.viewControllable.push(viewControllable: router.viewControllable, animated: true)
        self.attachChild(router)
        self.transferRouter = router
    }

    func dismissTransfer(animated: Bool) {
        guard let router = self.transferRouter else {
            return
        }

        self.viewController.popToBefore(viewControllable: router.viewControllable, animated: animated)
        self.detachChild(router)
        self.transferRouter = nil
    }

    func routeToChatTab() {
        if self.chatRouter == nil {
            self.chatRouter = self.chatBuilder.build(withListener: self.interactor)
            attachChild(self.chatRouter!)
        }

        self.viewController.embedViewController(self.chatRouter!.viewControllable)
    }

    func routeToTopUp() {
        guard self.topUpRouter == nil else {
            return
        }

        let router = self.topUpBuilder.build(withListener: self.interactor)
        self.viewControllable.push(viewControllable: router.viewControllable, animated: true)
        self.attachChild(router)
        self.topUpRouter = router
    }

    func dismissTopUp(animated: Bool) {
        guard let router = self.topUpRouter else {
            return
        }

        self.viewController.popToBefore(viewControllable: router.viewControllable, animated: animated)
        self.detachChild(router)
        self.topUpRouter = nil
    }

    func routeToWithdraw() {
        guard self.withdrawRouter == nil else {
            return
        }

        let router = self.withdrawBuilder.build(withListener: self.interactor)
        self.viewControllable.push(viewControllable: router.viewControllable, animated: true)
        self.attachChild(router)
        self.withdrawRouter = router
        if let viewModel = self.homeViewModel {
            self.withdrawRouter?.bind(homeViewModel: viewModel)
        }
    }

    func dismissWithdraw(animated: Bool) {
        guard let router = self.withdrawRouter else {
            return
        }

        self.viewController.popToBefore(viewControllable: router.viewControllable, animated: animated)
        self.detachChild(router)
        self.withdrawRouter = nil
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

    func dismissAddCard(animated: Bool) {
        guard let router = self.addCardRouter else {
            return
        }

        self.detachChild(router)
        self.viewController.popToBefore(viewControllable: router.viewControllable, animated: animated)
        self.addCardRouter = nil
    }

    func reloadCardData() {
        self.topUpRouter?.reloadData()
        self.transactionConfirmRouter?.reloadData()
        self.profileRouter?.reloadCardData()
    }

    func routeToTransactionConfirm(confirmData: [String: String], isShowPaymentMethodView: Bool) {
        guard self.transactionConfirmRouter == nil else {
            return
        }

        let router = self.transactionConfirmBuilder.build(withListener: interactor,
                                                          confirmData: confirmData,
                                                          isShowPaymentMethodView: isShowPaymentMethodView)
        self.attachChild(router)
        self.viewController.push(viewControllable: router.viewControllable, animated: true)
        self.transactionConfirmRouter = router
    }

    func dismissTransactionConfirm(animated: Bool) {
        guard let router = self.transactionConfirmRouter else {
            return
        }

        self.detachChild(router)
        self.viewController.popToBefore(viewControllable: router.viewControllable, animated: animated)
        self.transactionConfirmRouter = nil
    }

    func routeBackToHome() {
        self.dismissTransactionConfirm(animated: false)
        self.dismissTransfer(animated: false)
        self.dismissWithdraw(animated: false)
        self.dismissTopUp(animated: false)
        self.dismissEnterBill(animated: false)
        self.dismissChatDetails()
        self.routeToDashboardTab()
        if let homeViewControllable = self.viewControllable as? HomeViewControllable {
            homeViewControllable.routeToDashboard()
        }
    }

    func receiptWantToSeeDetails(transaction: Transaction) {
        self.dismissTransactionConfirm(animated: false)
        self.dismissTransfer(animated: false)
        self.dismissWithdraw(animated: false)
        self.dismissTopUp(animated: false)
        self.routeToHistoryTab()
        self.historyRouter?.routeToTransactionDetails(transaction: transaction, animated: false)
    }

    func receiptWantToRouteToChatDetail(with user: User) {
        self.dismissTransactionConfirm(animated: false)
        self.dismissTransfer(animated: false)
        self.routeToChatDetails(talker: user, animated: false)
    }

    func routeToEnterBill(serviceType: ServiceType) {
        guard self.enterBillRouter == nil else {
            return
        }

        let router = self.enterBillBuilder.build(withListener: self.interactor, serviceType: serviceType)
        self.viewController.push(viewControllable: router.viewControllable)
        self.attachChild(router)
        self.enterBillRouter = router
    }

    func dismissEnterBill(animated: Bool) {
        guard let router = self.enterBillRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.popToBefore(viewControllable: router.viewControllable, animated: animated)
        self.enterBillRouter = nil
    }

    func routeToQR() {
        guard self.qrRouter == nil else {
            return
        }

        let router = self.qrBuilder.build(withListener: self.interactor)
        self.viewController.push(viewControllable: router.viewControllable)
        self.attachChild(router)
        self.qrRouter = router
    }

    func dismissQR() {
        guard let router = self.qrRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.popToBefore(viewControllable: router.viewControllable)
        self.qrRouter = nil
    }

    func openTransactionDetails(transaction: Transaction) {
        self.routeToTab(homeTab: .history)
        self.historyRouter?.routeToTransactionDetails(transaction: transaction, animated: false)
    }

    func routeToChatDetails(talker: User, animated: Bool) {
        guard self.chatDetailsRouter == nil else {
            return
        }

        let router = self.chatDetailsBuilder.build(withListener: self.interactor, talker: talker)
        self.attachChild(router)
        self.viewControllable.push(viewControllable: router.viewControllable, animated: animated)
        self.chatDetailsRouter = router
    }

    func dismissChatDetails() {
        guard let router = self.chatDetailsRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.popToBefore(viewControllable: router.viewControllable)
        self.chatDetailsRouter = nil
    }
}
