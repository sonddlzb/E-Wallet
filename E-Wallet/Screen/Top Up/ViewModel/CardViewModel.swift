//
//  CardViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 17/04/2023.
//

import Foundation

struct CardViewModel {
    var listCards: [Card]

    static func makeEmpty() -> CardViewModel {
        return CardViewModel(listCards: [])
    }

    func item(at index: Int) -> CardItemViewModel {
        return CardItemViewModel(card: self.listCards[index])
    }

    func numberOfAccounts() -> Int {
        return self.listCards.count
    }
}
