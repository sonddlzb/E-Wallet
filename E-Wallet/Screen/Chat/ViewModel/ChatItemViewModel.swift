//
//  ChatItemViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 12/06/2023.
//

import Foundation

struct ChatItemViewModel {
    var talker: User
    var newestMessage: Message

    func name() -> String {
        return talker.fullName
    }

    func recentMessage() -> String {
        return newestMessage.content
    }

    func recentTime() -> String {
        return newestMessage.sendTime.formatToDayAndMonth()
    }

    func avatarURL() -> URL? {
        return URL(string: talker.avtURL)
    }
}
