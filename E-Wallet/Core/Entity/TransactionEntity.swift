//
//  TransactionEntity.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import Foundation

public enum PaymentStatus: String, CaseIterable {
    case pending
    case completed
    case failed

    func name() -> String {
        return self.rawValue.capitalized
    }
}

struct TransactionEntity: Codable {
    var type: String
    var senderId: String
    var receiverId: String
    var amount: Double
    var currency: String
    var status: String
    var time: Date
    var description: String
    var message = ""
}
