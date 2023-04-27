//
//  Transaction.swift
//  E-Wallet
//
//  Created by đào sơn on 18/04/2023.
//

import Foundation

class Transaction: Equatable, Hashable {
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var id: String
    var type: PaymentType
    var senderId: String
    var receiverId: String
    var amount: Double
    var currency: String
    var status: PaymentStatus
    var time: Date
    var description: String

    init(id: String, type: PaymentType, senderId: String, receiverId: String,
         amount: Double, currency: String, status: PaymentStatus, time: Date, description: String) {
        self.id = id
        self.type = type
        self.senderId = senderId
        self.receiverId = receiverId
        self.amount = amount
        self.currency = currency
        self.status = status
        self.time = time
        self.description = description
    }

    init(id: String, entity: TransactionEntity) {
        self.id = id
        self.type = PaymentType(rawValue: entity.type) ?? .transfer
        self.senderId = entity.senderId
        self.receiverId = entity.receiverId
        self.amount = entity.amount
        self.currency = entity.currency
        self.status = PaymentStatus(rawValue: entity.status) ?? .completed
        self.time = entity.time
        self.description = entity.description
    }
}
