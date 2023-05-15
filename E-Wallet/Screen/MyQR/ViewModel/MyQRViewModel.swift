//
//  ViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 12/05/2023.
//

import Foundation

struct MyQRViewModel {
    var userEntity: UserEntity

    func name() -> String {
        return userEntity.fullName
    }

    func phoneNumber() -> String {
        return userEntity.phoneNumber
    }
}
