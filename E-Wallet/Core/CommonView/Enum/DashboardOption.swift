//
//  DashboardOption.swift
//  E-Wallet
//
//  Created by đào sơn on 10/04/2023.
//

import Foundation
import UIKit

enum DashboardOption: String, CaseIterable {
    case transfer = "Transfer"
    case topUp = "Top Up"
    case withdraw = "Withdraw"
    case qrScan = "QR Scan"

    func name() -> String {
        return self.rawValue
    }

    func image() -> UIImage? {
        return UIImage(named: "ic_\(self.rawValue.lowercased())")
    }
}
