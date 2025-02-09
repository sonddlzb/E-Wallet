//
//  Message.swift
//  E-Wallet
//
//  Created by đào sơn on 12/06/2023.
//

import Foundation

enum MessageStatus: String {
    case sent
    case sendAndSeen
    case received
    case receivedAndSeen
}

enum MessageType: String {
    case image
    case audio
    case text
    case sendMoney
}

class Message {
    var id: String
    var content: String
    var senderId: String
    var receiverId: String
    var status: MessageStatus
    var type: MessageType
    var mediaLink: String
    var sendTime: Date
    var repliedId: String
    var amount: Double = 0.0
    var width: Double = 0.0
    var height: Double = 0.0
    var transactionId: String = ""

    init(id: String, content: String, senderId: String, receiverId: String, status: MessageStatus, type: MessageType, mediaLink: String, sendTime: Date, repliedId: String, amount: Double = 0.0, transactionId: String = "", width: Double = 0.0, height: Double = 0.0) {
        self.id = id
        self.content = content
        self.senderId = senderId
        self.receiverId = receiverId
        self.status = status
        self.type = type
        self.mediaLink = mediaLink
        self.sendTime = sendTime
        self.repliedId = repliedId
        self.amount = amount
        self.transactionId = transactionId
        self.width = width
        self.height = height
    }

    init(id: String, senderId: String, receiverId: String, entity: MessageEntity) {
        self.id = id
        self.content = entity.content
        self.senderId = senderId
        self.receiverId = receiverId
        self.status = MessageStatus(rawValue: entity.status) ?? .sent
        self.type = MessageType(rawValue: entity.type) ?? .text
        self.mediaLink = entity.mediaLink
        self.sendTime = entity.sendTime
        self.repliedId = entity.repliedId
        self.amount = entity.amount
        self.transactionId = entity.transactionId
        self.width = entity.width
        self.height = entity.height
    }
}
