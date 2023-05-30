//
//  NotificationMessageEntity.swift
//  E-Wallet
//
//  Created by đào sơn on 29/05/2023.
//

import Foundation

struct NotificationMessageEntity: Codable {
    var title: String
    var message: String
    var time: Double
    var transactionId: String
    var type: String
}
