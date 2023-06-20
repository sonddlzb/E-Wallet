//
//  TransactionConfirmViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import Foundation

struct TransactionConfirmViewModel {
    var confirmData: [String: String]
    var selectedCard: Card?
    var discount = 0.0

    static func makeEmpty() -> TransactionConfirmViewModel {
        return TransactionConfirmViewModel(confirmData: [:])
    }

    func numberOfData() -> Int {
        return self.listKeys().count
    }

    func listKeys() -> [String] {
        var listKeys: [String] = Array(self.confirmData.keys.sorted(by: <))
        listKeys.remove("cardId")
        return listKeys
    }

    func listValues() -> [String] {
        var listValues: [String] = []
        for key in self.listKeys() {
            listValues.append(confirmData[key]!)
        }

        return listValues
    }

    func item(at index: Int) -> TransactionConfirmItemViewModel {
        return TransactionConfirmItemViewModel(key: self.listKeys()[index], value: self.listValues()[index])
    }

    func amount() -> Double {
        let amount = self.confirmData["Amount"] ?? ""
        return String(amount.dropFirst()).toDouble() ?? 0.0
    }

    func paymentType() -> PaymentType? {
        let paymentType = self.confirmData["Payment Type"] ?? ""
        return PaymentType(rawValue: paymentType)
    }

    func phoneNumber() -> String {
        return self.confirmData["Phone number"] ?? ""
    }

    func cardId() -> String {
        return self.confirmData["cardId"] ?? ""
    }

    func billId() -> String {
        return self.confirmData["Bill ID"] ?? ""
    }

    func message() -> String {
        return self.confirmData["Message"] ?? ""
    }
}
