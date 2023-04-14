//
//  Account.swift
//  E-Wallet
//
//  Created by đào sơn on 13/04/2023.
//

import Foundation

struct AccountEntity: Codable {
    var currency: String
    var balance: Double
    var isActive: Bool
}
