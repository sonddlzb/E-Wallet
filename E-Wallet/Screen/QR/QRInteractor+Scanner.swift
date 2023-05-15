//
//  QRInteractor+Scanner.swift
//  E-Wallet
//
//  Created by đào sơn on 15/05/2023.
//

import Foundation

extension QRInteractor: ScannerListener {
    func scannerWantToRouteToTransfer(phoneNumber: String) {
        self.listener?.qrWantToRouteToTransfer(phoneNumber: phoneNumber)
    }
}
