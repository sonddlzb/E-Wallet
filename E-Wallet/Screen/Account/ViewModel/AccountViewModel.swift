//
//  AccountViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import Foundation

struct AccountViewModel {
    var listCards: [Card]

    static func makeEmpty() -> AccountViewModel {
        return AccountViewModel(listCards: [])
    }

    func item(at index: Int) -> AccountItemViewModel {
        return AccountItemViewModel(card: self.listCards[index])
    }

    func numberOfAccounts() -> Int {
        return self.listCards.count
    }
}
