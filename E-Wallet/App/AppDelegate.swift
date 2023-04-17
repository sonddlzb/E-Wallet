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

private struct Const {
    static let publishableKey = "pk_test_51MpNF2KkURD5t8wjxLZ80YMElFPJB1ySWCtZOijqIRQlZ0HeuSXZEVLgZZ6D0zTb5IoiD5xpt1e2uflfot3UxNMP0006CyNqiR"
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

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
    }

    private func configSVProgressHUD() {
        SVProgressHUD.setDefaultStyle(.dark)
    }

    private func configRemoteConfig() {
        RemoteConfigManager.shared.configRemoteConfigDefaults()
    }

    func configStripe() {
        STPAPIClient.shared.publishableKey = Const.publishableKey
    }
}
