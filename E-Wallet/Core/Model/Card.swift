//
//  Card.swift
//  HeliaHotelBooking
//
//  Created by đào sơn on 27/03/2023.
//

import Foundation

class Card {
    var id: String
    var cardNumber: String
    var expirationMonth: Int
    var expirationYear: Int
    var userId: String
    var cvc: String
    var token: String
    var type: CardType

    init(id: String,
         cardNumber: String,
         expirationMonth: Int,
         expirationYear: Int,
         userId: String,
         cvc: String,
         token: String,
         type: CardType) {
        self.id = id
        self.cardNumber = cardNumber
        self.expirationYear = expirationYear
        self.expirationMonth = expirationMonth
        self.userId = userId
        self.cvc = cvc
        self.token = token
        self.type = type
    }

    init(id: String, entity: CardEntity) {
        self.id = id
        self.userId = entity.userId
        self.expirationMonth = entity.expirationMonth
        self.expirationYear = entity.expirationYear
        self.cvc = entity.cvc
        self.cardNumber = entity.cardNumber
        self.token = entity.token
        self.type = CardType(rawValue: entity.type) ?? .masterCard
    }
}
