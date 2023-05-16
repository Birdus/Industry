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
     Called when a tab is selected  in the menu tab bar controller.
     
     - Parameters:
     - tabBarController: The menu tab bar controller.
     - index: The index of the selected tab.
     - data: The data of employee, load from api
     */
    func tabBarController(_ tabBarController: TabBarController, didSelectTabAtIndex index: Int, employee data: Employee)
    
    /**
     Called when a tab is selected  in the menu tab bar controller.
     
     - Parameters:
        - tabBarController: The menu tab bar controller.
        - index: The index of the selected tab.
        - data: The data of issues for employee, load from api
     */
    func tabBarController(_ tabBarController: TabBarController, didSelectTabAtIndex index: Int, issues datas: [Issues], employee data: Employee)
}

extension TabBarControllerDelegate {
    func tabBarController(_ tabBarController: TabBarController, didSelectTabAtIndex index: Int, employee data: Employee) {
        return
    }
    
    func tabBarController(_ tabBarController: TabBarController, didSelectTabAtIndex index: Int, issues datas: [Issues], employee data: Employee) {
        return
    }
}

class TabBarController: UITabBarController {
    
    /// The delegate for the menu tab bar controller.
    weak var delegete: TabBarControllerDelegate?
    private var employee: Employee?
    private var issues: [Issues] = []
    
    private var apiManagerIndustry: APIManagerIndustry? = APIManagerIndustry()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configure()
    }
    
    deinit {
        apiManagerIndustry = nil
    }
    
    private func loadData() {
        let group = DispatchGroup()
        
        group.enter()
        apiManagerIndustry?.fetch(request: ForecastType.EmployeeWitchId(id: 2), HTTPMethod: .get) { (json: [String: Any]) -> Employee? in
            defer {
                group.leave()
            }
            return Employee.decodeJSON(json: json)
        } completionHandler: { (result: APIResult<Employee?>) in
            switch result {
            case .success(let employee):
                if let employee = employee {
                    self.employee = employee
                } else {
                    print("Failed to parse employee.")
                }
            case .failure(let error):
                print("Error: \(error)")
            case .successArray(_):
                print("Expected single object, but got array.")
            }
        }
        
        group.wait()
        
        if let idLaborCosts = employee?.laborCosts?.compactMap({ $0.id }) {
            group.enter()
            apiManagerIndustry?.fetchIssues(HTTPMethod: .get, ids: idLaborCosts) { (json: [String: Any]) -> Issues? in
                defer {
                    group.leave()
                }
                return Issues.decodeJSON(json: json)
            } completionHandler: { (result: APIResult<[Issues]>) in
                switch result {
                case .success(let issues):
                    self.issues = issues
                case .failure(let error):
                    print("Error: \(error)")
                case .successArray(_):
                    print("Expected single object, but got array.")
                }
            }
            group.wait()
        }
    }
    
    
    
    
    
    private func configure() {
        // Create the view controllers for each tab.
        
        let vcCalendar = CalendarTaskViewController()
        self.delegete = vcCalendar
        let navigationControllerCalendar = UINavigationController(rootViewController: vcCalendar)
        
        if let employee = employee {
            delegete?.tabBarController(self, didSelectTabAtIndex: 0, issues: issues, employee: employee)
        }
        let vcDocumentFlow = DocumentFlowViewController()
        self.delegete = vcDocumentFlow
        
        let navigationControllerDocumentFlow = UINavigationController(rootViewController: vcDocumentFlow)
        
        let vcMenuUser = MenuViewController()
        self.delegete = vcMenuUser
        
        navigationControllerCalendar.isNavigationBarHidden = false
        navigationControllerDocumentFlow.isNavigationBarHidden = false
        // Set the tab bar items for each view controller.
        navigationControllerCalendar.tabBarItem = UITabBarItem(title: "Календарь".localized,
                                                               image: UIImage(named: "iconTask")?.withRenderingMode(.alwaysOriginal),
                                                               selectedImage: UIImage(named: "iconTaskSelected")?.withRenderingMode(.alwaysOriginal))
        navigationControllerDocumentFlow.tabBarItem = UITabBarItem(title: "Документооборот".localized,
                                                                   image: UIImage(named: "iconDocumentFlow")?.withRenderingMode(.alwaysOriginal),
                                                                   selectedImage: UIImage(named: "iconDocumentFlow")?.withRenderingMode(.alwaysOriginal))
        vcMenuUser.tabBarItem = UITabBarItem(title: "Мой профиль".localized,
                                             image: UIImage(named: "iconAccount")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "iconAccountSelected")?.withRenderingMode(.alwaysOriginal))
        // Set the view controllers for the tab bar.
        self.setViewControllers([navigationControllerCalendar, navigationControllerDocumentFlow, vcMenuUser], animated: true)
        self.delegate = self
        
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Call the menu delegate when a tab is selected.
        if let index = viewControllers?.firstIndex(of: viewController) {
            if let employee = employee {
                switch index {
                case 0:
                    delegete?.tabBarController(self, didSelectTabAtIndex: index, issues: issues, employee: employee)
                case 1:
                    break
                case 2:
                        delegete?.tabBarController(self, didSelectTabAtIndex: index, employee: employee)
                default:
                    break
                }
            }
        }
    }
}
