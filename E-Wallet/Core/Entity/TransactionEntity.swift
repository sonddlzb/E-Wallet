//
//  TransactionEntity.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import Foundation

public enum PaymentStatus: String {
    case pending
    case completed
    case failed
}

struct TransactionEntity: Codable {
    var type: String
    var senderId: String
    var receiverId: String
    var amount: Double
    var currency: String
    var status: String
    var time: String
}
