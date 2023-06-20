//
//  HomeInteractor+ChatDetails.swift
//  E-Wallet
//
//  Created by đào sơn on 19/06/2023.
//

import Foundation

extension HomeInteractor: ChatDetailsListener {
    func chatDetailsWantToDismiss() {
        self.router?.dismissChatDetails()
    }
}
