//
//  MessageEntity.swift
//  E-Wallet
//
//  Created by đào sơn on 12/06/2023.
//

import Foundation

struct MessageEntity: Codable {
    var content: String
    var status: String
    var type: String
    var mediaLink: String
    var sendTime: Date
    var repliedId: String
    var amount: Double = 0.0
    var transactionId: String = ""

    init(content: String, status: String, type: String, mediaLink: String, sendTime: Date, repliedId: String, amount: Double = 0.0, transactionId: String = "") {
        self.content = content
        self.status = status
        self.type = type
        self.mediaLink = mediaLink
        self.sendTime = sendTime
        self.repliedId = repliedId
        self.amount = amount
        self.transactionId = transactionId
    }

    init(dict: NSDictionary) {
        self.content = dict["content"] as? String ?? ""
        self.status = dict["status"] as? String ?? ""
        self.type = dict["type"] as? String ?? ""
        self.mediaLink = dict["mediaLink"] as? String ?? ""
        let sendTime = dict["sendTime"] as? Double ?? 0.0
        self.sendTime = Date(timeIntervalSinceReferenceDate: sendTime)
        self.repliedId = dict["repliedId"] as? String ?? ""
        self.amount = dict["amount"] as? Double ?? 0.0
        self.transactionId = dict["transactionId"] as? String ?? ""
    }
}
