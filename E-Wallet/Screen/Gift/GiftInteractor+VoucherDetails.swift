//
//  GiftInteractor+VoucherDetails.swift
//  E-Wallet
//
//  Created by đào sơn on 05/05/2023.
//

import Foundation

extension GiftInteractor: VoucherDetailsListener {
    func voucherDetailsWantToDismiss() {
        self.router?.dissmissVoucherDetails()
    }
}
