//
//  Message.swift
//  E-Wallet
//
//  Created by đào sơn on 12/06/2023.
//

import Foundation

enum MessageStatus: String {
    case sent
    case seen
    case notsent
}

enum MessageType: String {
    case image
    case video
    case text
    case sendMoney
    case requestMoney
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

    init(id: String, content: String, senderId: String, receiverId: String, status: MessageStatus, type: MessageType, mediaLink: String, sendTime: Date) {
        self.id = id
        self.content = content
        self.senderId = senderId
        self.receiverId = receiverId
        self.status = status
        self.type = type
        self.mediaLink = mediaLink
        self.sendTime = sendTime
    }

    init(id: String, entity: MessageEntity) {
        self.id = id
        self.content = entity.content
        self.senderId = entity.senderId
        self.receiverId = entity.receiverId
        self.status = MessageStatus(rawValue: entity.status) ?? .notsent
        self.type = MessageType(rawValue: entity.type) ?? .text
        self.mediaLink = entity.mediaLink
        self.sendTime = entity.sendTime.convertToDate() ?? Date()
    }
}
