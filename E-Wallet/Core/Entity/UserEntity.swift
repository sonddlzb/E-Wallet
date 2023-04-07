//
//  UserEntity.swift
//  E-Wallet
//
//  Created by đào sơn on 07/04/2023.
//

import Foundation

struct UserEntity: Codable {
    var fullName: String
    var residentId: String
    var dateOfBirth: String
    var phoneNumber: String
    var nativePlace: String
    var gender: String
    var avtURL: String
    var password: String
}
