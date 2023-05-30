//
//  AppDelegate.swift
//  E-Wallet
//
//  Created by đào sơn on 30/03/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseRemoteConfig
import SVProgressHUD
import Stripe
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow!
    var rootRouter: RootRouting?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DIConnector.registerAllDeps()
        self.configWindow()
        self.configFirebase()
        self.configSVProgressHUD()
        self.configStripe()
        self.configRemoteConfig()
        self.configNotification()
        return true
    }

    private func configNotification() {
        UNUserNotificationCenter.current().delegate = self
        let localNotificationHelper = LocalNotificationHelper()
        localNotificationHelper.notifications = [
            RemindNotification(id: "reminder-1", title: "Hey, someone want to connect with you in E-Wallet", datetime: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date().addingTimeInterval(60.0)))
        ]

        localNotificationHelper.schedule()
    }

    private func configWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        let component = AppComponent(window: window)
        let rootBuilder = DIContainer.resolve(RootBuildable.self, agrument: component)
        rootRouter = rootBuilder.build()
        rootRouter?.interactable.activate()
    }

    private func configFirebase() {
        FirebaseApp.configure()
    }

    private func configSVProgressHUD() {
        SVProgressHUD.setDefaultStyle(.dark)
    }

    private func configRemoteConfig() {
        RemoteConfigManager.shared.configRemoteConfigDefaults()
    }

    func configStripe() {
        STPAPIClient.shared.publishableKey = StripeConst.publishableKey
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let id = response.notification.request.identifier
        print("Received notification with ID = \(id)")
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let id = notification.request.identifier
        print("Received notification with ID = \(id)")
        completionHandler([.sound, .alert])
    }
}
