//
//  ChatDetailsItemViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 19/06/2023.
//

import Foundation

struct ChatDetailsItemViewModel {
    var message: Message

    func content() -> String {
        return message.content
    }

    func amount() -> String {
        return String(message.amount)
    }

    func transactionId() -> String {
        return message.transactionId
    }

    func mediaURL() -> URL? {
        return URL(string: self.message.mediaLink)
    }

    func scale() -> Double? {
        if message.height != 0, message.width != 0 {
            return message.width/message.height
        } else {
            return nil
        }
    }
}
