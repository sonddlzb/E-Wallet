//
//  HomeInteractor+Chat.swift
//  E-Wallet
//
//  Created by đào sơn on 19/06/2023.
//

import Foundation

extension HomeInteractor: ChatListener {
    func openChatFor(talker: User) {
        self.router?.routeToChatDetails(talker: talker)
    }
}
