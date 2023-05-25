//
//  HomeInteractor+Transfer.swift
//  E-Wallet
//
//  Created by đào sơn on 13/04/2023.
//

import Foundation

extension HomeInteractor: TransferListener {
    func transferWantToDismiss() {
        self.router?.dismissTransfer(animated: true)
    }

    func transferWantToRouteToTransactionConfirm(confirmData: [String: String]) {
        self.router?.routeToTransactionConfirm(confirmData: confirmData, isShowPaymentMethodView: true)
    }

    func transferWantToRouteToQRScanner() {
        self.router?.routeToQR()
    }
}
