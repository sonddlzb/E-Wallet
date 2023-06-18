//
//  User.swift
//  E-Wallet
//
//  Created by đào sơn on 27/04/2023.
//

import Foundation

class User: Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }

    var id: String
    var fullName: String
    var residentId: String
    var dateOfBirth: Date
    var phoneNumber: String
    var nativePlace: String
    var gender: String
    var avtURL: String
    var password: String

    init(id: String, entity: UserEntity) {
        self.id = id
        self.fullName = entity.fullName
        self.residentId = entity.residentId
        self.dateOfBirth = entity.dateOfBirth.convertToDate() ?? Date()
        self.phoneNumber = entity.phoneNumber
        self.nativePlace = entity.nativePlace
        self.gender = entity.gender
        self.avtURL = entity.avtURL
        self.password = entity.password
    }

    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
