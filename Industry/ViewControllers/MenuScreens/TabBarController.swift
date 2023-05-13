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
protocol TabBarControllerDelegate: AnyObject {
    /**
     Called when a tab is selected in the menu tab bar controller.
     
     - Parameters:
     - tabBarController: The menu tab bar controller.
     - index: The index of the selected tab.
     */
    func tabBarController(_ tabBarController: TabBarController, didSelectTabAtIndex index: Int)
}

class TabBarController: UITabBarController {
    
    /// The delegate for the menu tab bar controller.
    weak var menuDelegate: TabBarControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create the view controllers for each tab.
        let vcCalendar = UINavigationController(rootViewController: CalendarTaskViewController())
        let vcDocumentFlow = UINavigationController(rootViewController: DocumentFlowViewController())
        let vcMenuUser = MenuViewController()
        vcCalendar.isNavigationBarHidden = false
        vcDocumentFlow.isNavigationBarHidden = false
        // Set the tab bar items for each view controller.
        vcCalendar.tabBarItem = UITabBarItem(title: "Календарь".localized,
                                             image: UIImage(named: "iconTask")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "iconTaskSelected")?.withRenderingMode(.alwaysOriginal))
        vcDocumentFlow.tabBarItem = UITabBarItem(title: "Документооборот".localized,
                                                 image: UIImage(named: "iconDocumentFlow")?.withRenderingMode(.alwaysOriginal),
                                                 selectedImage: UIImage(named: "iconDocumentFlow")?.withRenderingMode(.alwaysOriginal))
        vcMenuUser.tabBarItem = UITabBarItem(title: "Мой профиль".localized,
                                             image: UIImage(named: "iconAccount")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "iconAccountSelected")?.withRenderingMode(.alwaysOriginal))
        // Set the view controllers for the tab bar.
        self.setViewControllers([vcCalendar, vcDocumentFlow, vcMenuUser], animated: true)
        self.delegate = self
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Call the menu delegate when a tab is selected.
        if let index = viewControllers?.firstIndex(of: viewController) {
            menuDelegate?.tabBarController(self, didSelectTabAtIndex: index)
        }
    }
}
