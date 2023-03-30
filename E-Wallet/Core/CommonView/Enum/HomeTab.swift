//
//  HomeTab.swift
//  TestCustomView
//
//  Created by đào sơn on 03/03/2023.
//

import UIKit

public enum HomeTab: String, CaseIterable {
    case home
    case search
    case booking
    case profile

    func getItemName() -> String {
        return self.rawValue.capitalized
    }

    func getItemImage(isFocus: Bool) -> UIImage? {
        if isFocus {
            return UIImage(named: "ic_\(self.rawValue)_focus")
        } else {
            return UIImage(named: "ic_\(self.rawValue)")
        }
    }
}
