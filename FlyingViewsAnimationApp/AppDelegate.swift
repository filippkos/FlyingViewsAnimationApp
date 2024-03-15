//
//  AppDelegate.swift
//  FlyingViewsAnimationApp
//
//  Created by Filipp Kosenko on 17.02.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let window = UIWindow()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.prepareRootController()
        
        return true
    }
    
    private func prepareRootController() {
        let navigationController = TestViewController()
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
}

