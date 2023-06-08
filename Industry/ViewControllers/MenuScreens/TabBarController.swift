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
        blurEffectView.accessibilityIdentifier = "blrLoad"
        return blurEffectView
    }()
    
    /// The activity indicator view  need for reload data
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.accessibilityIdentifier = "activityIndicator"
        return activityIndicator
    }()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        apiManagerIndustry = nil
        delegete.removeAll()
        print("sucsses closed TabBarController")
    }
    
    // MARK: - Privates func
    /// The func show alert when error in request to API
    private func showAlController(message: String) {
        let alControl:UIAlertController = {
            let alControl = UIAlertController(title: "Ошибка".localized, message: message, preferredStyle: .alert)
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
        if let employee = employee, let issues = issues {
            delegete.compactMap { $0 }.forEach {
                $0.tabBarController(self, didSelectTabAtIndex: selectedIndex, issues: issues, employee: employee)
            }
        }
    }
    
    /// The func need to refresh data in all view controller
    private func refreshData(completion: @escaping () -> Void) {
        guard let employee = employee else { return }
        apiManagerIndustry?.fetch(request: ForecastType.EmployeeWitchId(id: employee.id)) {(json: [String: Any]) -> Employee? in
            return Employee.decodeJSON(json: json)
        } completionHandler: { [weak self] (result: APIResult<Employee?>) in
            guard let self = self else { return }
            switch result {
            case .success(let employees):
                guard let employees = employees else {
                    DispatchQueue.main.async {
                        self.showAlController(message: INDNetworkingError.decodingFailed.errorMessage)
                    }
                    return
                }
                self.employee = employees
                let idLaborCosts = employees.laborCosts?.compactMap { $0.issueId } ?? []
                self.apiManagerIndustry?.fetchIssues(ids: idLaborCosts) {(json: [String: Any]) -> Issues? in
                    return Issues.decodeJSON(json: json)
                } completionHandler: { [weak self] (result: APIResult<[Issues]>) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let issues):
                        DispatchQueue.main.async {
                            self.issues = issues
                            completion()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.showAlController(message: error.localizedDescription)
                        }
                    case .successArray(_):
                        DispatchQueue.main.async {
                            self.showAlController(message: INDNetworkingError.decodingFailed.errorMessage)
                        }
                    }
                }
               
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlController(message: error.localizedDescription)
                }
            case .successArray(_):
                DispatchQueue.main.async {
                    self.showAlController(message: INDNetworkingError.decodingFailed.errorMessage)
                }
            }
        }
    }
}


// MARK: - EnterMenuViewControllerDelegate
extension TabBarController: EnterMenuViewControllerDelegate {
    /// This method is called when the EnterMenuViewController has loaded an employee with a specific ID.
    func enterMenuViewController(_ enterMenuViewController: EnterMenuViewController, didLoadEmployeeWitch id: Int, completion: @escaping () -> Void, failer: @escaping (Error) -> Void) {
        let errorNetwork = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.missingHTTPResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.missingHTTPResponse.localizedDescription])
        apiManagerIndustry?.fetch(request: ForecastType.EmployeeWitchId(id: id)) {(json: [String: Any]) -> Employee? in
            return Employee.decodeJSON(json: json)
        } completionHandler: { [weak self] (result: APIResult<Employee?>) in
            guard let self = self else { return }
            switch result {
            case .success(let employees):
                guard let employees = employees else {
                    DispatchQueue.main.async {
                        self.showAlController(message: INDNetworkingError.decodingFailed.errorMessage)
                        failer(errorNetwork)
                    }
                    return
                }
                self.employee = employees
                let idLaborCosts = employees.laborCosts?.compactMap { $0.issueId } ?? []
                self.apiManagerIndustry?.fetchIssues(ids: idLaborCosts) {(json: [String: Any]) -> Issues? in
                    return Issues.decodeJSON(json: json)
                } completionHandler: {[weak self] (result: APIResult<[Issues]>) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let issues):
                        self.issues = issues
                        DispatchQueue.main.async {
                            self.configure()
                            completion()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.showAlController(message: error.localizedDescription)
                            failer(error)
                        }
                    case .successArray(_):
                        DispatchQueue.main.async {
                            self.showAlController(message: INDNetworkingError.decodingFailed.errorMessage)
                            failer(errorNetwork)
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlController(message: error.localizedDescription)
                    failer(error)
                }
            case .successArray(_):
                DispatchQueue.main.async {
                    self.showAlController(message: INDNetworkingError.decodingFailed.errorMessage)
                    failer(errorNetwork)
                }
            }
        }
    }
}

// MARK: - AppDelegateDelegate
extension TabBarController: AppDelegateDelegate {
    /// This method is called when the AppDelegate has loaded an employee with a specific ID.
    func appDelegate(_ appDelegate: AppDelegate, didLoadEmployeeWith id: Int, completion: @escaping () -> Void, failure failer: @escaping (Error) -> Void) {
        let errorNetwork = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.missingHTTPResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.missingHTTPResponse.localizedDescription])
        apiManagerIndustry?.fetch(request: ForecastType.EmployeeWitchId(id: id)) {(json: [String: Any]) -> Employee? in
            return Employee.decodeJSON(json: json)
        } completionHandler: { [weak self] (result: APIResult<Employee?>) in
            guard let self = self else { return }
            switch result {
            case .success(let employees):
                guard let employees = employees else {
                    DispatchQueue.main.async {
                        self.showAlController(message: INDNetworkingError.decodingFailed.errorMessage)
                        failer(errorNetwork)
                    }
                    return
                }
                self.employee = employees
                let idLaborCosts = employees.laborCosts?.compactMap { $0.issueId } ?? []
                self.apiManagerIndustry?.fetchIssues(ids: idLaborCosts) {(json: [String: Any]) -> Issues? in
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
                        DispatchQueue.main.async {
                            self.showAlController(message: error.localizedDescription)
                            failer(error)
                        }
                    case .successArray(_):
                        DispatchQueue.main.async {
                            self.showAlController(message: INDNetworkingError.decodingFailed.errorMessage)
                            failer(errorNetwork)
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlController(message: error.localizedDescription)
                    failer(error)
                }
            case .successArray(_):
                DispatchQueue.main.async {
                    self.showAlController(message: INDNetworkingError.decodingFailed.errorMessage)
                    failer(errorNetwork)
                }
            }
        }
    }
}

// MARK: - CalendarTaskViewControllerDelegate
extension TabBarController: CalendarTaskViewControllerDelegate {
    func calendarTaskViewController(_ viewController: CalendarTaskViewController, didLoadEmployees: [Employee], isues: Issues, laborCoast: LaborCost, project: Project) {
        return
    }
    
    func calendarTaskViewController(_ viewController: CalendarTaskViewController, didLoadEmployee: Employee, isues: Issues, laborCoast: LaborCost, project: Project) {
        return
    }
    
    /// This method is called when the CalendarTaskViewController has deleted data with a specific ID.
    func calendarTaskViewController(_ viewController: CalendarTaskViewController, didDeleateData witchId: Int) {
        apiManagerIndustry?.deleteItem(request: ForecastType.IssueWithId(id: witchId)) { result in
            switch result {
            case .success:
                self.refreshData() { [weak self] in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if let employee = self.employee, let issues = self.issues {
                            self.delegete.forEach { $0.tabBarController(self, didSelectTabAtIndex: self.selectedIndex, issues: issues, employee: employee) }
                            self.activityIndicator.stopAnimating()
                            self.blrLoad.removeFromSuperview()
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlController(message: error.localizedDescription)
                }
            case .successArray(_):
                DispatchQueue.main.async {
                    self.showAlController(message: INDNetworkingError.decodingFailed.errorMessage)
                }
            }
        }
    }
    
    /// This methodis called when the CalendarTaskViewController is loaded.
    func calendarTaskViewController(_ viewController: CalendarTaskViewController) {
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
