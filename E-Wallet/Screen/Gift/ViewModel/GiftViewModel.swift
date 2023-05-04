//
//  GiftViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 04/05/2023.
//

import Foundation

struct GiftViewModel: Equatable {
    var listVouchers: [Voucher]

    static func makeEmpty() -> GiftViewModel {
        return GiftViewModel(listVouchers: [])
    }

    func numberOfVouchers() -> Int {
        return self.listVouchers.count
    }

    func item(at index: Int) -> GiftItemViewModel {
        return GiftItemViewModel(voucher: self.listVouchers[index])
    }

    static func == (lhs: GiftViewModel, rhs: GiftViewModel) -> Bool {
        return lhs.listVouchers.map{ $0.id} == rhs.listVouchers.map{ $0.id}
    }
}
