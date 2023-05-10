//
//  GiftApplyViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 09/05/2023.
//

import Foundation

struct GiftApplyViewModel {
    var listVouchers: [Voucher]

    static func makeEmpty() -> GiftApplyViewModel {
        return GiftApplyViewModel(listVouchers: [])
    }

    func numberOfVouchers() -> Int {
        return self.listVouchers.count
    }

    func item(at index: Int) -> GiftApplyItemViewModel {
        return GiftApplyItemViewModel(voucher: self.listVouchers[index])
    }

    func voucher(at index: Int) -> Voucher {
        return self.listVouchers[index]
    }

    func isEmpty() -> Bool {
        return self.listVouchers.isEmpty
    }
}
