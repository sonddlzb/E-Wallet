//
//  TransactionConfirmViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import Foundation

struct TransactionConfirmViewModel {
    var confirmData: [String: String]

    static func makeEmpty() -> TransactionConfirmViewModel {
        return TransactionConfirmViewModel(confirmData: [:])
    }

    func numberOfData() -> Int {
        return confirmData.count
    }

    func listKeys() -> [String] {
        return Array(self.confirmData.keys)
    }

    func listValues() -> [String] {
        return Array(self.confirmData.values)
    }

    func item(at index: Int) -> TransactionConfirmItemViewModel {
        return TransactionConfirmItemViewModel(key: self.listKeys()[index], value: self.listValues()[index])
    }

    func amount() -> Double {
        let amount = self.confirmData["Amount"] ?? ""
        return String(amount.dropFirst()).toDouble() ?? 0.0
    }

    func paymentType() -> PaymentType? {
        var paymentType = self.confirmData["Payment Type"] ?? ""
        return PaymentType(rawValue: paymentType)
    }

    func phoneNumber() -> String {
        return self.confirmData["Phone number"] ?? ""
    }
}
