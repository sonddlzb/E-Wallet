//
//  FilterSelectionItemViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 28/04/2023.
//

import Foundation
import UIKit

struct FilterSelectionItemViewModel {
    var selection: String

    func image() -> UIImage? {
        return UIImage(named: "ic_\(selection.lowercased())_history")
    }
}
