//
//  BillEntity.swift
//  E-Wallet
//
//  Created by đào sơn on 05/05/2023.
//

import Foundation

struct BillEntity: Codable {
    var customerId: String
    var supplier: String
    var customerName: String
    var address: String
    var status: String
    var amount: Double
    var period: String
    var type: String
}
