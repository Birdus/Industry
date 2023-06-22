//
//  AppDelegate.swift
//  Industry
//
//  Created by birdus on 24.02.2023.
//

import UIKit
import JWTDecode
import KeychainSwift
import UserNotifications

protocol AppDelegateDelegate: AnyObject {
    func appDelegate(_ appDelegate: AppDelegate, didLoadEmployeeWith id: Int, completion: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void)
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private weak var delegate: AppDelegateDelegate!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if ProcessInfo.processInfo.arguments.contains("-resetUser") {
            KeychainSwift().clear()
        }
        let apiManager = APIManagerIndustry()
        window = UIWindow(frame: UIScreen.main.bounds)
        let splashViewController = SplachViewController()
        let splashNavController = UINavigationController(rootViewController: splashViewController)
        window?.rootViewController = splashNavController
        window?.makeKeyAndVisible()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if apiManager.haveAuthTokens && apiManager.haveAuthBody {
                apiManager.refreshTokens { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        if let token = apiManager.getAccessToken() {
                            do {
                                let jwt = try decode(jwt: token.token)
                                if let idEmployee = jwt.claim(name: "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier").integer {
                                    self.loadEmployeeWithID(idEmployee)
                                }
                            } catch {
                                print(error)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            } else {
                let enterMenuViewController = EnterMenuViewController()
                let navController = UINavigationController(rootViewController: enterMenuViewController)
                navController.modalPresentationStyle = .fullScreen
                navController.isToolbarHidden = true
                navController.isNavigationBarHidden = true
                self.window?.rootViewController = navController
                self.window?.makeKeyAndVisible()
                let transition = CATransition()
                transition.duration = 0.7
                transition.type = .fade
                self.window?.layer.add(transition, forKey: kCATransition)
            }
        }
        
        return true
    }
    
    private func loadEmployeeWithID(_ id: Int) {
        DispatchQueue.main.async {
            let tabBarController = TabBarController()
            self.delegate = tabBarController
            self.delegate.appDelegate(self, didLoadEmployeeWith: id, completion: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    let navController = UINavigationController(rootViewController: tabBarController)
                    navController.modalPresentationStyle = .fullScreen
                    navController.isToolbarHidden = true
                    navController.isNavigationBarHidden = true
                    self.window?.rootViewController = navController
                    self.window?.makeKeyAndVisible()
                    
                    let transition = CATransition()
                    transition.duration = 0.7
                    transition.type = .fade
                    self.window?.layer.add(transition, forKey: kCATransition)
                }
            }, failure: { error in
                print(error)
            })
        }
    }
    
    
}

