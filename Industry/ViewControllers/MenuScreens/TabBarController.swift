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
    // MARK: - Properties
    /// The delegate for the menu tab bar controller.
    weak var delegeteCalendar: TabBarControllerDelegate?
    weak var delegeteDocumentFlow: TabBarControllerDelegate?
    weak var delegeteMenuUser: TabBarControllerDelegate?
    private var employee: Employee?
    private var issues: [Issues] = []
    
    private var apiManagerIndustry: APIManagerIndustry? = APIManagerIndustry()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    deinit {
        apiManagerIndustry = nil
    }
    
    
    // MARK: - Privates func
    private func configure() {
        // Create the view controllers for each tab.
        let vcCalendar = CalendarTaskViewController()
        self.delegeteCalendar = vcCalendar
        if let employee = self.employee {
            self.delegeteCalendar?.tabBarController(self, didSelectTabAtIndex: 0, issues: self.issues, employee: employee)
            let navigationControllerCalendar = UINavigationController(rootViewController: vcCalendar)
            let vcDocumentFlow = DocumentFlowViewController()
            self.delegeteDocumentFlow = vcDocumentFlow
            let navigationControllerDocumentFlow = UINavigationController(rootViewController: vcDocumentFlow)
            let vcMenuUser = MenuViewController()
            self.delegeteMenuUser = vcMenuUser
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
    
    private func loadData() {
        if let employee = employee {
            apiManagerIndustry?.fetch(request: ForecastType.EmployeeWitchId(id: employee.id), HTTPMethod: .get) { (json: [String: Any]) -> Employee? in
                return Employee.decodeJSON(json: json)
            } completionHandler: { [weak self] (result: APIResult<Employee?>) in
                guard let self = self else { return }
                switch result {
                case .success(let employees):
                    if self.employee != employees {
                        if let employees = employees {
                            self.employee = employees
                            if let idLaborCosts = employees.laborCosts?.compactMap({ $0.issueId }) {
                                self.apiManagerIndustry?.fetchIssues(HTTPMethod: .get, ids: idLaborCosts) { (json: [String: Any]) -> Issues? in
                                    return Issues.decodeJSON(json: json)
                                } completionHandler: { [weak self] (result: APIResult<[Issues]>) in
                                    guard let self = self else { return }
                                    switch result {
                                    case .success(let issues):
                                        self.issues = issues
                                        DispatchQueue.main.async {
                                            self.configure()
                                        }
                                    case .failure(let error):
                                        print("Error: \(error)")
                                    case .successArray(_):
                                        print("Expected single objects, but got array.")
                                    }
                                }
                            }
                        } else {
                            print("Failed to parse employees.")
                        }
                    }
                case .failure(let error):
                    print("Error: \(error)")
                case .successArray(_):
                    print("Expected single object, but got array.")
                }
            }
        }
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
                    loadData()
                    delegeteCalendar?.tabBarController(self, didSelectTabAtIndex: index, issues: issues, employee: employee)
                case 1:
                    break
                case 2:
                    loadData()
                    delegeteMenuUser?.tabBarController(self, didSelectTabAtIndex: index, employee: employee)
                default:
                    break
                }
            }
        }
    }
}

// MARK: - EnterMenuViewControllerDelegate
extension TabBarController: EnterMenuViewControllerDelegate {
    
    func enterMenuViewController(_ enterMenuViewController: EnterMenuViewController, didLoadEmployeeWitch id: Int, completion: @escaping () -> Void, failer: @escaping (Error) -> Void) {
        let errorNetwork = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.missingHTTPResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.missingHTTPResponse.localizedDescription])
        apiManagerIndustry?.fetch(request: ForecastType.EmployeeWitchId(id: id), HTTPMethod: .get) { (json: [String: Any]) -> Employee? in
            return Employee.decodeJSON(json: json)
        } completionHandler: { [weak self] (result: APIResult<Employee?>) in
            guard let self = self else { return }
            switch result {
            case .success(let employees):
                if let employees = employees {
                    self.employee = employees
                    if let idLaborCosts = employees.laborCosts?.compactMap({ $0.issueId }) {
                        self.apiManagerIndustry?.fetchIssues(HTTPMethod: .get, ids: idLaborCosts) { (json: [String: Any]) -> Issues? in
                            return Issues.decodeJSON(json: json)
                        } completionHandler: { [weak self] (result: APIResult<[Issues]>) in
                            guard let self = self else { return }
                            switch result {
                            case .success(let issues):
                                self.issues = issues
                                DispatchQueue.main.async {
                                    self.configure()
                                }
                                completion()
                            case .failure(let error):
                                print("Error: \(error)")
                                failer(error)
                            case .successArray(_):
                                
                                print("Expected single objects, but got array.")
                                failer(errorNetwork)
                            }
                        }
                    }
                } else {
                    print("Failed to parse employees.")
                    failer(errorNetwork)
                }
            case .failure(let error):
                print("Error: \(error)")
                failer(error)
            case .successArray(_):
                print("Expected single object, but got array.")
                failer(errorNetwork)
            }
        }
    }
}
