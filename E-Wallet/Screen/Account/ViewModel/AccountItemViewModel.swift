//
//  AccountItemViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import Foundation
import UIKit

struct AccountItemViewModel {
    var card: Card

    func image() -> UIImage? {
        return self.card.type.image()
    }

    func cardNumber() -> String {
        return ".... .... .... " + self.card.cardNumber.suffix(4)
    }
}
