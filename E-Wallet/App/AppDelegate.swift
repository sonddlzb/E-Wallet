//
//  AppDelegate.swift
//  E-Wallet
//
//  Created by đào sơn on 30/03/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow!
    var rootRouter: RootRouting?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DIConnector.registerAllDeps()
        self.configWindow()
        self.configFirebase()
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
}
