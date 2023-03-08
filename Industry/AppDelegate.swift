//
//  AppDelegate.swift
//  Industry
//
//  Created by birdus on 24.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let navVc = UINavigationController(rootViewController: EnterMenuViewController())
            let splashVcNav = UINavigationController(rootViewController: SplachViewController())
            window?.rootViewController = splashVcNav
            window?.makeKeyAndVisible()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                        self.window?.rootViewController = navVc
                    }
            return true
        }
}

