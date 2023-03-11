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
        
        let vcTaskList = TaskListViewController()
        let vcUserTask = TaskListViewController()
        let vcEnterMenu = EnterMenuViewController()
        // let vc3 = ViewController()
        
        vcTaskList.tabBarItem = UITabBarItem(title: "Задачи", image: UIImage(named: "iconTask")?.withRenderingMode(.automatic), selectedImage: UIImage(named: "iconTask")?.withRenderingMode(.automatic))
        vcUserTask.tabBarItem = UITabBarItem(title: "Мои задачи", image: UIImage(named: "iconUserTask")?.withRenderingMode(.automatic), selectedImage: UIImage(named: "iconUserTask")?.withRenderingMode(.automatic))
        vcEnterMenu.tabBarItem = UITabBarItem(title: "Мои профиль", image: UIImage(named: "iconAccount")?.withRenderingMode(.automatic), selectedImage: UIImage(named: "iconAccount")?.withRenderingMode(.automatic))
        
        // vc3.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 2)
        
        self.viewControllers = [vcTaskList, vcUserTask, vcEnterMenu]
        
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
