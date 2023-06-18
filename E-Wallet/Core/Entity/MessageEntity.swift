//
//  MessageEntity.swift
//  E-Wallet
//
//  Created by đào sơn on 12/06/2023.
//

import Foundation

struct MessageEntity: Codable {
    var content: String
    var senderId: String
    var receiverId: String
    var status: String
    var type: String
    var mediaLink: String
    var sendTime: String

    init(dict: NSDictionary) {
        self.content = dict["content"] as? String ?? ""
        self.senderId = dict["senderId"] as? String ?? ""
        self.receiverId = dict["receiverId"] as? String ?? ""
        self.status = dict["status"] as? String ?? ""
        self.type = dict["type"] as? String ?? ""
        self.mediaLink = dict["mediaLink"] as? String ?? ""
        self.sendTime = dict["sendTime"] as? String ?? ""
    }
}
