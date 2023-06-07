//
//  NotificationsViewModel.swift
//  E-Wallet
//
//  Created by đào sơn on 30/05/2023.
//

import Foundation

struct NotificationsViewModel {
    var listNotifications: [NotificationMessage]

    static func makeEmpty() -> NotificationsViewModel {
        return NotificationsViewModel(listNotifications: [])
    }

    func item(at index: Int) -> NotificationsItemViewModel {
        return NotificationsItemViewModel(notificationMessage: self.listNotifications[index])
    }

    func numberOfNotifications() -> Int {
        return self.listNotifications.count
    }
}
