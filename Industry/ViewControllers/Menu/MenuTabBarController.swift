//
//  MenuTabBarController.swift
//  Industry
//
//  Created by Даниил on 11.03.2023.
//
/**
 A custom UITabBarController used for the Industry app's menu bar.

 - Author: Daniil
 - Version: 1.0
 */

import UIKit

// MARK: - MenuTabBarControllerDelegate

protocol MenuTabBarControllerDelegate: AnyObject {
    /**
         Called when a tab is selected in the menu tab bar controller.
         
         - Parameters:
            - tabBarController: The menu tab bar controller.
            - index: The index of the selected tab.
         */
    func menuTabBarController(_ tabBarController: MenuTabBarController, didSelectTabAtIndex index: Int)
}

class MenuTabBarController: UITabBarController {
    
    /// The delegate for the menu tab bar controller.
    weak var menuDelegate: MenuTabBarControllerDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Hide the navigation bar and set the tab bar's autoresizing mask.
        self.navigationController?.isNavigationBarHidden = true
        self.tabBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the view controllers for each tab.
        let vcTaskList = UINavigationController(rootViewController: CalendarTaskViewController())
        let vcUserTask = UINavigationController(rootViewController: NotificationListViewController())
        let vcProfileUser = UINavigationController(rootViewController: ProfileUserViewController())
        
        // Set the tab bar items for each view controller.
        vcTaskList.tabBarItem = UITabBarItem(title: "Календарь".localized,
                                             image: UIImage(named: "iconTask")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "iconTaskSelected")?.withRenderingMode(.alwaysOriginal))
        vcUserTask.tabBarItem = UITabBarItem(title: "Уведомления".localized,
                                             image: UIImage(named: "iconNotification")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "iconNotificationSelected")?.withRenderingMode(.alwaysOriginal))
        vcProfileUser.tabBarItem = UITabBarItem(title: "Мой профиль".localized,
                                                image: UIImage(named: "iconAccount")?.withRenderingMode(.alwaysOriginal),
                                                selectedImage: UIImage(named: "iconAccountSelected")?.withRenderingMode(.alwaysOriginal))
        
        // Set the view controllers for the tab bar.
        self.viewControllers = [vcTaskList, vcUserTask, vcProfileUser]
        self.delegate = self
    }
}

// MARK: - UITabBarControllerDelegate

extension MenuTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Call the menu delegate when a tab is selected.
        if let index = viewControllers?.firstIndex(of: viewController) {
            menuDelegate?.menuTabBarController(self, didSelectTabAtIndex: index)
        }
    }
}
