//
//  ProfileViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 11/04/2023.
//

import Foundation

struct ProfileViewModel {
    var userEntity: UserEntity

    func avtURL() -> URL? {
        return URL(string: userEntity.avtURL)
    }
}
