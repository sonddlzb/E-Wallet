//
//  ProfileOption.swift
//  E-Wallet
//
//  Created by đào sơn on 12/04/2023.
//

import Foundation
import UIKit

enum ProfileOption: String, CaseIterable {
    case paymentManagement = "Payment Management"
    case expenseManagement = "Expense Management"
    case changePassword = "Change Password"
    case voucher = "Voucher"
    case feedback = "Feedback"
    case setting = "Setting"

    func image() -> UIImage? {
        return UIImage(named: "ic_\(self.rawValue.lowercased())")
    }

    func name() -> String {
        return self.rawValue
    }
}
