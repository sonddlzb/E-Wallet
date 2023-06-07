//
//  NotificationsItemViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 30/05/2023.
//

import Foundation
import UIKit

struct NotificationsItemViewModel {
    var notificationMessage: NotificationMessage

    func image() -> UIImage? {
        let index: Int = (Int(notificationMessage.time.timeIntervalSinceReferenceDate) % 10)/2
        return UIImage(named: "ic_mascot_noti_" + String(index))
    }

    func date() -> String {
        return self.notificationMessage.time.formatDate()
    }

    func message() -> String {
        return self.notificationMessage.message
    }
}
