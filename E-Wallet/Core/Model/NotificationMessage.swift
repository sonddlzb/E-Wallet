//
//  NotificationMessage.swift
//  E-Wallet
//
//  Created by đào sơn on 29/05/2023.
//

import Foundation

class NotificationMessage {
    var message: String
    var title: String
    var transactionId: String
    var time: Date
    var type: String

    init(transactionId: String, message: String, time: Date, title: String, type: String) {
        self.transactionId = transactionId
        self.message = message
        self.time = time
        self.title = title
        self.type = type
    }

    init(entity: NotificationMessageEntity) {
        self.transactionId = entity.transactionId
        self.title = entity.title
        self.message = entity.message
        self.time = Date(timeIntervalSinceReferenceDate: entity.time)
        self.type = entity.type
    }

    init(dict: [String: Any]) {
        self.transactionId = dict["transactionId"] as? String ?? ""
        self.message = dict["message"] as? String ?? ""
        self.title = dict["title"] as? String ?? ""
        self.type = dict["type"] as? String ?? ""
        self.time = Date(timeIntervalSinceReferenceDate: dict["time"] as? Double ?? 0.0) 
    }
}
