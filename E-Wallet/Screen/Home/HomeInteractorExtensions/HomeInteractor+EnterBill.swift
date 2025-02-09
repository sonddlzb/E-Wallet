//
//  HomeInteractor+EnterBill.swift
//  E-Wallet
//
//  Created by đào sơn on 05/05/2023.
//

import Foundation

extension HomeInteractor: EnterBillListener {
    func enterBillWantToDismiss() {
        self.router?.dismissEnterBill(animated: true)
    }

    func billDetailsWantToRouteToTransactionConfirn(confirmData: [String: String]) {
        self.router?.routeToTransactionConfirm(confirmData: confirmData, isShowPaymentMethodView: true)
    }
}
