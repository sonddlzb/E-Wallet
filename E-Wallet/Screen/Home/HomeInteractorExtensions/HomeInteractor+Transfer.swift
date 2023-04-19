//
//  HomeInteractor+Transfer.swift
//  E-Wallet
//
//  Created by đào sơn on 13/04/2023.
//

import Foundation

extension HomeInteractor: TransferListener {
    func transferWantToDismiss() {
        self.router?.dismissTransfer()
    }

    func transferWantToRouteToTransactionConfirm(confirmData: [String: Any], phoneNumber: String) {
        self.router?.routeToTransactionConfirm(confirmData: confirmData, paymentType: .transfer)
    }
}
