//
//  AppDelegate.swift
//  Calculator
//
//  Created by Takehito Koshimizu on 2022/07/10.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }
}
