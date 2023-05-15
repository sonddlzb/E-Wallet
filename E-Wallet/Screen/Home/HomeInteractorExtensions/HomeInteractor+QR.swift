//
//  HomeInteractor+Scanner.swift
//  E-Wallet
//
//  Created by đào sơn on 11/05/2023.
//

import Foundation

extension HomeInteractor: QRListener {
    func qrWantToDismiss() {
        self.router?.dismissQR()
    }

    func qrWantToRouteToTransfer(phoneNumber: String) {
        self.router?.dismissQR()
        self.router?.routeToTransfer(phoneNumber: phoneNumber)
    }
}
