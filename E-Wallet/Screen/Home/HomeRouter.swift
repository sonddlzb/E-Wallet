//
//  HomeRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import RIBs

protocol HomeInteractable: Interactable, DashboardListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    func embedViewController(_ viewControlller: ViewControllable)
    func highlightOnTabBar(tab: HomeTab)
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable> {

    var currentTab: HomeTab = .dashboard

    private var dashboardRouter: DashboardRouting?
    private var dashboardBuilder: DashboardBuildable

    init(interactor: HomeInteractable,
         viewController: HomeViewControllable,
         dashboardBuilder: DashboardBuildable) {
        self.dashboardBuilder = dashboardBuilder
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
            print("route to account")
        case .myProfile:
            print("route to my profile")
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
}
