//
//  AppDelegate.swift
//  E-Wallet
//
//  Created by đào sơn on 30/03/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import FirebaseRemoteConfig
import SVProgressHUD
import Stripe
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

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

        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }

        return true
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
        Messaging.messaging().delegate = self
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
        print("Presented notification with ID = \(id)")
        completionHandler([.sound, .alert])
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // save token of device for send notification to firebase
        print("FCMToken: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}
