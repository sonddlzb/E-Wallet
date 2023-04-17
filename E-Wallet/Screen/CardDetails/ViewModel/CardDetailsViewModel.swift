//
//  CardDetailsViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 17/04/2023.
//

import Foundation

struct CardDetailsViewModel {
    var card: Card
    var listKeys = ["max_top_up", "max_withdraw", "min_top_up",
                    "min_withdraw", "top_up_rate", "withdraw_rate"]

    func cardNumber() -> String {
        return self.card.cardNumber
    }

    func cvc() -> String {
        return self.card.cvc
    }

    func expirationYear() -> UInt {
        return UInt(self.card.expirationYear)
    }

    func expirationMonth() -> UInt {
        return UInt(self.card.expirationMonth)
    }

    func item(at index: Int) -> CardDetailsItemViewModel {
        return CardDetailsItemViewModel(key: self.listKeys[index])
    }

    func numberOfKeys() -> Int {
        return self.listKeys.count
    }
}
