//
//  MenuTabBarController.swift
//  Industry
//
//  Created by Даниил on 11.03.2023.
//

import UIKit

protocol MenuTabBarControllerDelegate: AnyObject {
    func menuTabBarControllerDelegate(_ tabController: MenuTabBarController, didSelectTab index: Int)
}

class MenuTabBarController: UITabBarController {
    
    weak var delegete: MenuTabBarControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vcTaskList = CalendarTaskViewController()
        let vcUserTask = NotificationListViewController()
        let vcProfileUser = ProfileUserViewController()
        
        vcTaskList.tabBarItem = UITabBarItem(title: "Календарь".localized, image: UIImage(named: "iconTask")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "iconTaskSelected")?.withRenderingMode(.alwaysOriginal))
        vcUserTask.tabBarItem = UITabBarItem(title: "Уведомления", image: UIImage(named: "iconNotification")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "iconNotificationSelected")?.withRenderingMode(.alwaysOriginal))
        vcProfileUser.tabBarItem = UITabBarItem(title: "Мои профиль", image: UIImage(named: "iconAccount")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "iconAccountSelected")?.withRenderingMode(.alwaysOriginal))
        
        self.viewControllers = [vcTaskList, vcUserTask, vcProfileUser]
        
        // Добавляем TabBar к главному контроллеру
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = .systemBlue
        self.tabBar.isTranslucent = false
        
        self.delegate = self
    }
    
}

extension MenuTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let index = viewControllers?.firstIndex(of: viewController) {
            delegete?.menuTabBarControllerDelegate(self, didSelectTab: index)
        }
    }
}
