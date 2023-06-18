//
//  HomeTab.swift
//  TestCustomView
//
//  Created by đào sơn on 03/03/2023.
//

import UIKit

public enum HomeTab: String, CaseIterable {
    case dashboard = "Dashboard"
    case gift = "Gift"
    case history = "History"
    case chat = "Chat"
    case myProfile = "My Profile"

    func getItemName() -> String {
        return self.rawValue
    }

    func getItemImage(isFocus: Bool) -> UIImage? {
        if isFocus {
            return UIImage(named: "ic_\(self.rawValue.trim().lowercased())_focus")
        } else {
            return UIImage(named: "ic_\(self.rawValue.trim().lowercased())")
        }
    }

    func canHighlighted() -> Bool {
        return true
    }
}
