//
//  ChatMenuItemViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 27/06/2023.
//

import Foundation
import UIKit

struct ChatMenuItemViewModel {
    var option: ChatMenuOption

    func name() -> String {
        return option.name()
    }

    func image() -> UIImage? {
        return option.image()
    }
}
