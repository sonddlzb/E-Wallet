//
//  GiftInteractor+GiftArea.swift
//  E-Wallet
//
//  Created by đào sơn on 18/07/2023.
//

import Foundation

extension GiftInteractor: GiftAreaListener {
    func giftAreaWantToDismiss() {
        self.router?.dismissGiftArea()
    }

    func giftAreaWantToOpenService(_ serviceType: ServiceType) {
        self.listener?.giftWantToOpenService(serviceType)
    }
}
