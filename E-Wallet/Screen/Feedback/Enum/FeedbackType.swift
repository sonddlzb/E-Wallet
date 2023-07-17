//
//  FeedbackType.swift
//  E-Wallet
//
//  Created by đào sơn on 17/07/2023.
//

import Foundation
import UIKit

enum FeedbackType: String, CaseIterable {
    case worst = "Worst"
    case notGood = "Not Good"
    case fine = "Fine"
    case lookGood = "Look Good"
    case veryGood = "Very Good"

    func image(isFocus: Bool) -> UIImage? {
        return UIImage(named: "ic_" + self.rawValue.lowercased() + "_" + (isFocus ? "focus" : "not_focus"))
    }
}
