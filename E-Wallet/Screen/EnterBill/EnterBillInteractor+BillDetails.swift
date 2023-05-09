//
//  EnterBillInteractor+BillDetails.swift
//  E-Wallet
//
//  Created by đào sơn on 08/05/2023.
//

import Foundation

extension EnterBillInteractor: BillDetailsListener {
    func billDetailsWantToRouteToTransactionConfirn(confirmData: [String: String]) {
        self.listener?.billDetailsWantToRouteToTransactionConfirn(confirmData: confirmData)
    }

    func billDetailsWantToDismiss() {
        self.router?.dismissBillDetails()
    }
}
