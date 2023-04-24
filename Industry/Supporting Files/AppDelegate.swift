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
        self.window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
            UIView.animate(withDuration: 0.1, animations: {
                self.window?.rootViewController = navVc
                self.window?.makeKeyAndVisible()
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = .push
                transition.subtype = .fromRight
                self.window?.layer.add(transition, forKey: kCATransition)
            })
        }
        return true
    }

}

