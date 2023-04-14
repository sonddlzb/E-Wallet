//
//  CardEntity.swift
//  HeliaHotelBooking
//
//  Created by đào sơn on 27/03/2023.
//

import Foundation

struct CardEntity: Codable {
    var cardNumber: String
    var expirationMonth: Int
    var expirationYear: Int
    var userId: String
    var cvc: String
    var token: String
    var type: String
}
