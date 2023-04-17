//
//  HomeRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import RIBs

protocol HomeInteractable: Interactable, DashboardListener, ProfileListener, TransferListener, AccountListener, TopUpListener, AddCardListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    func embedViewController(_ viewControlller: ViewControllable)
    func highlightOnTabBar(tab: HomeTab)
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

    private var accountRouter: AccountRouting?
    private var accountBuilder: AccountBuildable

    private var topUpRouter: TopUpRouting?
    private var topUpBuilder: TopUpBuildable

    private var addCardRouter: AddCardRouting?
    private var addCardBuilder: AddCardBuildable

    init(interactor: HomeInteractable,
         viewController: HomeViewControllable,
         dashboardBuilder: DashboardBuildable,
         profileBuilder: ProfileBuildable,
         transferBuilder: TransferBuildable,
         accountBuilder: AccountBuildable,
         topUpBuilder: TopUpBuildable,
         addCardBuilder: AddCardBuildable) {
        self.dashboardBuilder = dashboardBuilder
        self.profileBuilder = profileBuilder
        self.transferBuilder = transferBuilder
        self.accountBuilder = accountBuilder
        self.topUpBuilder = topUpBuilder
        self.addCardBuilder = addCardBuilder
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
            print("route to gift")
        case .history:
            print("route to history")
        case .account:
            self.routeToAccountTab()
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
    }

    func routeToTransfer() {
        guard self.transferRouter == nil else {
            return
        }

        let router = self.transferBuilder.build(withListener: self.interactor)
        self.viewControllable.push(viewControllable: router.viewControllable, animated: true)
        self.attachChild(router)
        self.transferRouter = router
    }

    func dismissTransfer() {
        guard let router = self.transferRouter else {
            return
        }

        self.viewController.popToBefore(viewControllable: router.viewControllable)
        self.detachChild(router)
        self.transferRouter = nil
    }

    func routeToAccountTab() {
        if self.accountRouter == nil {
            self.accountRouter = self.accountBuilder.build(withListener: self.interactor)
            attachChild(self.accountRouter!)
        }

        self.viewController.embedViewController(self.accountRouter!.viewControllable)
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

    func dismissTopUp() {
        guard let router = self.topUpRouter else {
            return
        }

        self.viewController.popToBefore(viewControllable: router.viewControllable)
        self.detachChild(router)
        self.topUpRouter = nil
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

    func reloadCardData() {
        self.accountRouter?.reloadData()
        self.topUpRouter?.reloadData()
    }
}
