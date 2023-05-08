//
//  Bill.swift
//  E-Wallet
//
//  Created by đào sơn on 05/05/2023.
//

import Foundation

enum BillStatus: String {
    case processing
    case purchased
    case unpurchased
}

class Bill {
    var id: String
    var customerId: String
    var supplier: String
    var customerName: String
    var address: String
    var status: BillStatus
    var amount: Double
    var period: String
    var type: ServiceType

    init(id: String, customerId: String, supplier: String, customerName: String, address: String, status: BillStatus, amount: Double, period: String, type: ServiceType) {
        self.id = id
        self.customerId = customerId
        self.supplier = supplier
        self.customerName = customerName
        self.address = address
        self.status = status
        self.amount = amount
        self.period = period
        self.type = type
    }

    init(id: String, entity: BillEntity) {
        self.id = id
        self.customerId = entity.customerId
        self.supplier = entity.supplier
        self.customerName = entity.customerName
        self.address = entity.address
        self.status = BillStatus(rawValue: entity.status.lowercased()) ?? .unpurchased
        self.amount = entity.amount
        self.period = entity.period
        self.type = ServiceType(rawValue: entity.type) ?? .others
    }
}
