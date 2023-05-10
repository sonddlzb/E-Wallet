//
//  GiftInteractor+VoucherDetails.swift
//  E-Wallet
//
//  Created by đào sơn on 05/05/2023.
//

import Foundation

extension GiftInteractor: VoucherDetailsListener {
    func voucherDetailsWantTransactionConfirmToUse(voucher: Voucher) {

    }

    func voucherDetailsWantToDismiss() {
        self.router?.dissmissVoucherDetails()
    }
}
