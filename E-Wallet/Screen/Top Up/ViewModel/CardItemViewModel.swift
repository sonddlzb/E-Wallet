//
//  CardItemViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 17/04/2023.
//

import Foundation
import UIKit

struct CardItemViewModel {
    var card: Card

    func image() -> UIImage? {
        return self.card.type.image()
    }

    func cardNumber() -> String {
        return ".... .... .... " + self.card.cardNumber.suffix(4)
    }

    func name() -> String {
        return self.card.type.rawValue.capitalized
    }
}
