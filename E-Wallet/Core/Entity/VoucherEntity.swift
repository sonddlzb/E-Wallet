//
//  VoucherEntity.swift
//  E-Wallet
//
//  Created by đào sơn on 04/05/2023.
//

import Foundation

struct VoucherEntity: Codable {
    var description: String
    var discountType: String
    var openTime: Date
    var amount: Double
    var expirationTime: Date
    var minValue: Double
    var maxDiscount: Double
    var userId: String
    var serviceTypes: [String]
}
