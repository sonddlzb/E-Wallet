//
//  HomeViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 13/04/2023.
//

import Foundation

struct HomeViewModel {
    var userEntity: UserEntity
    var accountEntity: AccountEntity

    func balance() -> Double {
        return accountEntity.balance
    }

    func name() -> String {
        return userEntity.fullName
    }

    func phoneNumber() -> String {
        return userEntity.phoneNumber
    }

    func currency() -> String {
        return accountEntity.currency
    }

    func avtURL() -> URL? {
        return URL(string: userEntity.avtURL)
    }
}
