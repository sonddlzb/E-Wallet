//
//  ServiceType.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import Foundation
import UIKit

enum ServiceType: String, CaseIterable {
    case electricity = "Electricity"
    case water = "Water"
    case internet = "Internet"
    case televison = "TV"
    case prepaidTopUp = "Prepaid Top-up"
    case cinema = "Cinema"
    case tuition = "Tuition"
    case others = "Others"

    func image() -> UIImage? {
        return UIImage(named: "ic_" + self.rawValue.lowercased())
    }

    func name() -> String {
        return self.rawValue
    }
}
