//
//  GiftApplyInteractor+VoucherDetails.swift
//  E-Wallet
//
//  Created by đào sơn on 10/05/2023.
//

import Foundation

extension GiftApplyInteractor: VoucherDetailsListener {
    func voucherDetailsWantToOpenGiftArea(voucher: Voucher) {

    }

    func voucherDetailsWantToDismiss() {
        self.router?.dismissVoucherDetails(animated: true)
    }

    func voucherDetailsWantTransactionConfirmToUse(voucher: Voucher) {
        self.router?.dismissVoucherDetails(animated: false)
        self.listener?.giftApplyWantToApply(voucher: voucher)
    }
}
