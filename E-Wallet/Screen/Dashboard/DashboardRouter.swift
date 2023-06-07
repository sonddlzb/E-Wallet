//
//  DashboardRouter.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import RIBs

protocol DashboardInteractable: Interactable, NotificationsListener {
    var router: DashboardRouting? { get set }
    var listener: DashboardListener? { get set }

    func bind(homeViewModel: HomeViewModel)
}

protocol DashboardViewControllable: ViewControllable {
}

final class DashboardRouter: ViewableRouter<DashboardInteractable, DashboardViewControllable> {

    private var notificationsRouter: NotificationsRouting?
    private var notificationsBuilder: NotificationsBuildable

    init(interactor: DashboardInteractable,
         viewController: DashboardViewControllable,
         notificationsBuilder: NotificationsBuildable) {
        self.notificationsBuilder = notificationsBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

// MARK: - DashboardRouting
extension DashboardRouter: DashboardRouting {
    func bind(homeViewModel: HomeViewModel) {
        self.interactor.bind(homeViewModel: homeViewModel)
    }

    func routeToNotifications() {
        guard self.notificationsRouter == nil else {
            return
        }

        let router = self.notificationsBuilder.build(withListener: self.interactor)
        self.attachChild(router)
        self.viewControllable.push(viewControllable: router.viewControllable)
        self.notificationsRouter = router
    }

    func dismissNotifications() {
        guard let router = self.notificationsRouter else {
            return
        }

        self.detachChild(router)
        self.viewControllable.popToBefore(viewControllable: router.viewControllable)
        self.notificationsRouter = nil
    }
}
