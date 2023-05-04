//
//  Voucher.swift
//  E-Wallet
//
//  Created by đào sơn on 04/05/2023.
//

import Foundation

enum DiscountType: String {
    case percent
    case number
}

class Voucher {
    var id: String
    var description: String
    var discountType: DiscountType
    var openTime: Date
    var amount: Double
    var expirationTime: Date
    var minValue: Double
    var maxDiscount: Double
    var userId: String
    var serviceTypes: [ServiceType]

    init(id: String, description: String, discountType: DiscountType, openTime: Date, amount: Double, expirationTime: Date, minValue: Double, maxDiscount: Double, userId: String, serviceTypes: [ServiceType]) {
        self.id = id
        self.description = description
        self.discountType = discountType
        self.openTime = openTime
        self.amount = amount
        self.expirationTime = expirationTime
        self.minValue = minValue
        self.maxDiscount = maxDiscount
        self.userId = userId
        self.serviceTypes = serviceTypes
    }

    init(id: String, entity: VoucherEntity) {
        self.id = id
        self.description = entity.description
        self.discountType = DiscountType(rawValue: entity.discountType) ?? .number
        self.openTime = entity.openTime
        self.amount = entity.amount
        self.expirationTime = entity.expirationTime
        self.minValue = entity.minValue
        self.maxDiscount = entity.maxDiscount
        self.userId = entity.userId
        self.serviceTypes = entity.serviceTypes.map {ServiceType(rawValue: $0) ?? .others}
    }
}
