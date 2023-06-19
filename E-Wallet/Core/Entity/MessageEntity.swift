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

    init(dict: NSDictionary) {
        self.content = dict["content"] as? String ?? ""
        self.status = dict["status"] as? String ?? ""
        self.type = dict["type"] as? String ?? ""
        self.mediaLink = dict["mediaLink"] as? String ?? ""
        let sendTime = dict["sendTime"] as? Double ?? 0.0
        self.sendTime = Date(timeIntervalSinceReferenceDate: sendTime)
        self.repliedId = dict["repliedId"] as? String ?? ""
    }
}
