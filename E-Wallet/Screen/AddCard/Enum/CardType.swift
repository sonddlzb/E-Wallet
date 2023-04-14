//
//  CardType.swift
//  E-Wallet
//
//  Created by đào sơn on 14/04/2023.
//

import UIKit

enum CardType: String, CaseIterable {
    case amex
    case visa
    case masterCard
    case maestro
    case dinersClub
    case jcb
    case discover
    case unionPay

    func image() -> UIImage? {
        return UIImage(named: "ic_\(self.rawValue.lowercased())")
    }

    func regex() -> String {
        switch self {
        case .amex: return "^3[47][0-9]{5,}$"
        case .visa: return "^4[0-9]{6,}$"
        case .masterCard: return "^5[1-5][0-9]{5,}$"
        case .maestro: return "^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$"
        case .dinersClub: return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .jcb: return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .discover: return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .unionPay: return "^62[0-5]\\d{13,16}$"
        }
    }
}

