//
//  HomeInteractor+Gift.swift
//  E-Wallet
//
//  Created by đào sơn on 18/07/2023.
//

import Foundation

extension HomeInteractor: GiftListener {
    func giftWantToOpenService(_ serviceType: ServiceType) {
        self.router?.routeToEnterBill(serviceType: serviceType)
    }
}
