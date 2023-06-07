//
//  DashboardInteractor+Notifications.swift
//  E-Wallet
//
//  Created by đào sơn on 02/06/2023.
//

import Foundation

extension DashboardInteractor: NotificationsListener {
    func notificationsWantToDismiss() {
        self.router?.dismissNotifications()
    }
}
