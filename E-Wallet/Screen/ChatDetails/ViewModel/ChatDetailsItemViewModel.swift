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
}
