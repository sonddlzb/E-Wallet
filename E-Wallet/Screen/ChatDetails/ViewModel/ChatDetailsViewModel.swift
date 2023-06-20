//
//  ChatDetailsViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 19/06/2023.
//

import Foundation

struct ChatDetailsViewModel {
    var talker: User
    var listMessages: [Message]

    func item(at index: Int) -> ChatDetailsItemViewModel {
        return ChatDetailsItemViewModel(message: self.listMessages[index])
    }

    func name() -> String {
        return talker.fullName
    }

    func imageURL() -> URL? {
        return URL(string: talker.avtURL)
    }

    func numberOfMessages() -> Int {
        return self.listMessages.count
    }

    func content(at index: Int) -> String {
        return self.listMessages[index].content
    }
}
