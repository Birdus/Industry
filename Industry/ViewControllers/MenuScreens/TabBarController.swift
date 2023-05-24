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
        - datas: The data of array Issues, load from api
        - data: The data of Employee, load from api
     */
    func tabBarController(_ tabBarController: TabBarController, didSelectTabAtIndex index: Int, issues datas: [Issues], employee data: Employee)
}

class TabBarController: UITabBarController {
    // MARK: - Properties
    /// The delegate for the menu tab bar controller.
    private var delegete: [TabBarControllerDelegate] = []
    private var employee: Employee?
    private var issues: [Issues]?
    private var apiManagerIndustry: APIManagerIndustry? = APIManagerIndustry()
    
    // MARK: - Private UI
    /// The visual effect view blur need for reload data
    private lazy var blrLoad: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.5
        return blurEffectView
    }()
    
    /// The activity indicator view  need for reload data
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        apiManagerIndustry = nil
        delegete.removeAll()
    }
    
    // MARK: - Privates func
    /// The func show alert when error in request to API
    private func showAlController() {
        let alControl:UIAlertController = {
            let alControl = UIAlertController(title: "Ошибка".localized, message: INDNetworkingError.serverError.errorMessage, preferredStyle: .alert)
            let btnOk: UIAlertAction = {
                let btn = UIAlertAction(title: "Ok".localized,
                                        style: .default,
                                        handler: nil )
                return btn
            }()
            alControl.addAction(btnOk)
            return alControl
        }()
        self.present(alControl, animated: true, completion: nil)
    }
    
    /// The func configure tab controller and send data on api all view controller content the tab controller
    private func configure() {
        
        let vcCalendar = CalendarTaskViewController()
        let navigationControllerCalendar = UINavigationController(rootViewController: vcCalendar)
        vcCalendar.delegete = self
        let vcDocumentFlow = DocumentFlowViewController()
        let navigationControllerDocumentFlow = UINavigationController(rootViewController: vcDocumentFlow)
        
        let vcMenuUser = ProfileUserViewController()
        delegete.append(vcMenuUser)
        delegete.append(vcDocumentFlow)
        delegete.append(vcCalendar)
        
        navigationControllerCalendar.isNavigationBarHidden = false
        navigationControllerDocumentFlow.isNavigationBarHidden = false
        
        navigationControllerCalendar.tabBarItem = UITabBarItem(title: "Календарь".localized,
                                                               image: UIImage(named: "iconTask")?.withRenderingMode(.alwaysOriginal),
                                                               selectedImage: UIImage(named: "iconTaskSelected")?.withRenderingMode(.alwaysOriginal))
        
        navigationControllerDocumentFlow.tabBarItem = UITabBarItem(title: "Документооборот".localized,
                                                                   image: UIImage(named: "iconDocumentFlow")?.withRenderingMode(.alwaysOriginal),
                                                                   selectedImage: UIImage(named: "iconDocumentFlow")?.withRenderingMode(.alwaysOriginal))
        
        vcMenuUser.tabBarItem = UITabBarItem(title: "Мой профиль".localized,
                                             image: UIImage(named: "iconAccount")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "iconAccountSelected")?.withRenderingMode(.alwaysOriginal))
        
        setViewControllers([navigationControllerCalendar, navigationControllerDocumentFlow, vcMenuUser], animated: true)
        delegate = self
        
        if let employee = employee, let issues = issues {
            delegete.compactMap { $0 }.forEach {
                $0.tabBarController(self, didSelectTabAtIndex: selectedIndex, issues: issues, employee: employee)
            }
        }
    }
    
    /// The func need to refresh data in all view controller
    private func refreshData(completion: @escaping () -> Void) {
        guard let employee = employee else { return }
        apiManagerIndustry?.fetch(request: ForecastType.EmployeeWitchId(id: employee.id), HTTPMethod: .get) {(json: [String: Any]) -> Employee? in
            return Employee.decodeJSON(json: json)
        } completionHandler: { [weak self] (result: APIResult<Employee?>) in
            guard let self = self else { return }
            switch result {
            case .success(let employees):
                guard let employees = employees else {
                    print("Failed to parse employees.")
                    DispatchQueue.main.async {
                        self.showAlController()
                        completion() // Вызываем замыкание после завершения обновления данных
                    }
                    return
                }
                if employees != self.employee {
                    self.employee = employees
                    let idLaborCosts = employees.laborCosts?.compactMap { $0.issueId } ?? []
                    self.apiManagerIndustry?.fetchIssues(HTTPMethod: .get, ids: idLaborCosts) {(json: [String: Any]) -> Issues? in
                        return Issues.decodeJSON(json: json)
                    } completionHandler: { [weak self] (result: APIResult<[Issues]>) in
                        guard let self = self else { return }
                        switch result {
                        case .success(let issues):
                            self.issues = issues
                            completion()
                        case .failure(let error):
                            print("Error: \(error)")
                            DispatchQueue.main.async {
                                self.showAlController()
                                completion()
                            }
                        case .successArray(_):
                            print("Expected single objects, but got array.")
                            DispatchQueue.main.async {
                                self.showAlController()
                                completion()
                            }
                        }
                    }
                }
                completion()
            case .failure(let error):
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.showAlController()
                    completion()
                }
            case .successArray(_):
                print("Expected single object, but got array.")
                DispatchQueue.main.async {
                    self.showAlController()
                    completion()
                }
            }
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        refreshData() { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let employee = self.employee, let issues = self.issues {
                    self.delegete.forEach { $0.tabBarController(self, didSelectTabAtIndex: self.selectedIndex, issues: issues, employee: employee) }
                }
            }
        }
    }
}

// MARK: - EnterMenuViewControllerDelegate
extension TabBarController: EnterMenuViewControllerDelegate {
    func enterMenuViewController(_ enterMenuViewController: EnterMenuViewController, didLoadEmployeeWitch id: Int, completion: @escaping () -> Void, failer: @escaping (Error) -> Void) {
        let errorNetwork = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.missingHTTPResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.missingHTTPResponse.localizedDescription])
        
        apiManagerIndustry?.fetch(request: ForecastType.EmployeeWitchId(id: id), HTTPMethod: .get) {(json: [String: Any]) -> Employee? in
            return Employee.decodeJSON(json: json)
        } completionHandler: { [weak self] (result: APIResult<Employee?>) in
            guard let self = self else { return }
            switch result {
            case .success(let employees):
                guard let employees = employees else {
                    print("Failed to parse employees.")
                    failer(errorNetwork)
                    return
                }
                self.employee = employees
                let idLaborCosts = employees.laborCosts?.compactMap { $0.issueId } ?? []
                self.apiManagerIndustry?.fetchIssues(HTTPMethod: .get, ids: idLaborCosts) {(json: [String: Any]) -> Issues? in
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

// MARK: - CalendarTaskViewControllerDelegate
extension TabBarController: CalendarTaskViewControllerDelegate {
    func calendarTaskViewController(_ viewController: UIViewController, didDeleateData witchId: Int) {
        apiManagerIndustry?.deleteItem(request: ForecastType.IssueWithId(id: witchId)) { result in
            switch result {
            case .success:
                self.refreshData() { [weak self] in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if let employee = self.employee, let issues = self.issues {
                            self.delegete.forEach { $0.tabBarController(self, didSelectTabAtIndex: self.selectedIndex, issues: issues, employee: employee) }
                        }
                    }
                }
            case .failure(let error):
                print("Error deleting item: \(error)")
                self.showAlController()
            case .successArray(_):
                print("Expected single object, but got array.")
                self.showAlController()
            }
        }
    }
    
    func calendarTaskViewController(_ viewController: UIViewController) {
        self.view.addSubview(blrLoad)
        blrLoad.contentView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        refreshData() { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let employee = self.employee, let issues = self.issues {
                    self.delegete.forEach { $0.tabBarController(self, didSelectTabAtIndex: self.selectedIndex, issues: issues, employee: employee) }
                    self.activityIndicator.stopAnimating()
                    self.blrLoad.removeFromSuperview()
                }
            }
        }
    }
}
