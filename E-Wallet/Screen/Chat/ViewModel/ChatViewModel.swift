//
//  ChatViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 12/06/2023.
//

import Foundation

struct ChatViewModel {
    var listNewestMessages: [Message]
    var listTalkers: [User]

    static func makeEmpty() -> ChatViewModel {
        return ChatViewModel(listNewestMessages: [], listTalkers: [])
    }

    func item(at index: Int) -> ChatItemViewModel {
        return ChatItemViewModel(talker: listTalkers[index], newestMessage: listNewestMessages[index])
    }

    func numberOfTalkers() -> Int {
        return self.listTalkers.count
    }

    func message(at index: Int) -> Message {
        return self.listNewestMessages[index]
    }
}
