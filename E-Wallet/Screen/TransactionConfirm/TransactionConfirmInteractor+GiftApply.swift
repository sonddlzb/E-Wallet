//
//  TransactionConfirmInteractor+GiftApply.swift
//  E-Wallet
//
//  Created by đào sơn on 09/05/2023.
//

import Foundation

extension TransactionConfirmInteractor: GiftApplyListener {
    func giftApplyWantToDismiss() {
        self.router?.dismissGiftApply()
    }

    func giftApplyWantToApply(voucher: Voucher) {
        self.router?.dismissGiftApply()
        if voucher.discountType == .percent {
            self.viewModel.discount = min(self.viewModel.amount()*voucher.amount/100, voucher.maxDiscount)
        } else {
            self.viewModel.discount = min(self.viewModel.amount(), voucher.amount)
        }

        self.voucher = voucher
        self.presenter.bind(viewModel: self.viewModel)
        self.presenter.bind(voucher: voucher)
    }

    func giftDetailsWantTransactionConfirmToUse(voucher: Voucher) {
        self.router?.dismissGiftApply()
        self.voucher = voucher
        self.presenter.bind(voucher: voucher)
    }
}
