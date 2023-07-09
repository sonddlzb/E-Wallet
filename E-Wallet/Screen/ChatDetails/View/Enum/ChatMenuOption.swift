//
//  ChatMenuOption.swift
//  E-Wallet
//
//  Created by đào sơn on 27/06/2023.
//

import Foundation
import UIKit

enum ChatMenuOption: String, CaseIterable {
    case transfer
    case request
    case photo
    case voice

    func image() -> UIImage? {
        return UIImage(named: "ic_chat_menu_\(self.rawValue)")
    }

    func name() -> String {
        switch self {
        case .transfer: return "Transfer money"
        case .request: return "Request money"
        case .photo: return "Send photo"
        case .voice: return "Voice message"
        }
    }
}
