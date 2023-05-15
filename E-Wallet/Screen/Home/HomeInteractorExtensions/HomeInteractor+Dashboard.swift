//
//  HomeInteractor+Dashboard.swift
//  E-Wallet
//
//  Created by đào sơn on 13/04/2023.
//

import Foundation

extension HomeInteractor: DashboardListener {
    func dashboadWantToRouteToTransfer() {
        self.router?.routeToTransfer(phoneNumber: nil)
    }

    func dashboadWantToRouteToTopUp() {
        self.router?.routeToTopUp()
    }

    func dashboadWantToRouteToWithdraw() {
        self.router?.routeToWithdraw()
    }

    func dashboardWantToRouteToEnterBill(serviceType: ServiceType) {
        self.router?.routeToEnterBill(serviceType: serviceType)
    }

    func dashboardWantToRouteToQR() {
        self.router?.routeToQR()
    }
}
