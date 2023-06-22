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

    /// The `Employee` object associated with the tab bar controller.
    private var employee: Employee?

    /// The `Issues` objects associated with the tab bar controller.
    private var issues: [Issues]?

    /// The `APIManagerIndustry` object used for API calls.
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
    /// This fumc show alelrt controoler
    ///
    /// - Parameter messege: The messege show alert controller
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
        vcMenuUser.delegete = self
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
    
    private func resizeImage(_ image: UIImage, to targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }

    
    /// Refreshes data in all view controllers.
    ///
    /// - Parameters:
    ///   - completion: A closure that is called when the operation is complete.
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
                    let errorsUser = INDNetworkingError.init(error)
                    self.showAlController(message: errorsUser.errorMessage)
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
    /// Called when the EnterMenuViewController loads an employee with a specific ID.
    ///
    /// - Parameters:
    ///   - enterMenuViewController: The `EnterMenuViewController` that is notifying the delegate of the load.
    ///   - id: The ID of the employee that was loaded.
    ///   - completion: A closure that is called when the operation is complete.
    ///   - failer: A closure that is called when the operation fails. This closure takes an `Error` as input.
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
                            let errorsUser = INDNetworkingError.init(error)
                            self.showAlController(message: errorsUser.errorMessage)
                            failer(errorsUser)
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
                    let errorsUser = INDNetworkingError.init(error)
                    self.showAlController(message: errorsUser.errorMessage)
                    failer(errorsUser)
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
    /// Called when the AppDelegate loads an employee with a specific ID.
    ///
    /// - Parameters:
    ///   - appDelegate: The `AppDelegate` that is notifying the delegate of the load.
    ///   - id: The ID of the employee that was loaded.
    ///   - completion: A closure that is called when the operation is complete.
    ///   - failer: A closure that is called when the operation fails. This closure takes an `Error` as input.
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
                            let errorsUser = INDNetworkingError.init(error)
                            self.showAlController(message: errorsUser.errorMessage)
                            failer(errorsUser)
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
                    let errorsUser = INDNetworkingError.init(error)
                    self.showAlController(message: errorsUser.errorMessage)
                    failer(errorsUser)
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
    /// Called when the calendar task view controller loads employees.
    ///
    /// - Parameters:
    ///   - viewController: The `CalendarTaskViewController` that is notifying the delegate of the load.
    ///   - didLoadEmployees: The loaded `Employee` objects.
    ///   - isues: The `Issues` associated with the employees.
    ///   - laborCoast: The `LaborCost` associated with the employees.
    ///   - project: The `Project` associated with the employees.
    func calendarTaskViewController(_ viewController: CalendarTaskViewController, didLoadEmployees: [Employee], isues: Issues, laborCoast: LaborCost, project: Project) {
        return
    }
    
    /// Called when the calendar task view controller loads an employee.
    ///
    /// - Parameters:
    ///   - viewController: The `CalendarTaskViewController` that is notifying the delegate of the load.
    ///   - didLoadEmployee: The loaded `Employee` object.
    ///   - isues: The `Issues` associated with the employee.
    ///   - laborCoast: The `LaborCost` associated with the employee.
    ///   - project: The `Project` associated with the employee.
    func calendarTaskViewController(_ viewController: CalendarTaskViewController, didLoadEmployee: Employee, isues: Issues, laborCoast: LaborCost, project: Project) {
        return
    }
    
    /// Called when the calendar task view controller deletes data with a specific ID.
    ///
    /// - Parameters:
    ///   - viewController: The `CalendarTaskViewController` that is notifying the delegate of the deletion.
    ///   - witchId: The ID of the data that was deleted.
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
    
    /// Called when the calendar task view controller is loaded.
    ///
    /// - Parameters:
    ///   - viewController: The `CalendarTaskViewController` that is notifying the delegate of the load.
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

// MARK: - ProfileUserViewControllerDelegate
extension TabBarController: ProfileUserViewControllerDelegate {
    /// Called when the profile user view controller exports an employee image.
    ///
    /// - Parameters:
    ///   - viewController: The `ProfileUserViewController` that is notifying the delegate of the export.
    ///   - imageUser: The exported `UIImage`.
    func profileUserViewController(_ viewController: ProfileUserViewController, didExportEmployee imageUser: UIImage) {
        blrLoad.contentView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        guard let employee = employee else {
            return
        }
        let targetImageSize = CGSize(width: 100, height: 100)
        guard let resizedImage = resizeImage(imageUser, to: targetImageSize), let imageData = resizedImage.pngData() else {
            return
        }
        UserDefaults.standard.set(imageData, forKey: "UserImage")
        apiManagerIndustry?.uploadImage(request: ForecastType.UploadImage(id: employee.id), employee: employee ) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.blrLoad.removeFromSuperview()
                }
            case .failure(let error):
                let errorUser = INDNetworkingError.init(error)
                self.showAlController(message: errorUser.errorMessage)
            }
        }
    }
    
    /// Called when the profile user view controller loads an employee image.
    ///
    /// - Parameters:
    ///   - viewController: The `ProfileUserViewController` that is notifying the delegate of the load.
    ///   - imageUser: A closure that takes a `UIImage` as input and has no return value.
    func profileUserViewController(_ viewController: ProfileUserViewController, didLoadEmployee imageUser: @escaping (UIImage) -> Void) {
        guard let employee = employee else {
            return
        }
        guard let imageData = UserDefaults.standard.data(forKey: "UserImage"), let image = UIImage(data: imageData) else {
            let url = ForecastType.LoadImage
            apiManagerIndustry?.fetchImage(request: url, imagePath: employee.iconPath) { result in
                switch result {
                case .success(let fetchedImage):
                    imageUser(fetchedImage)
                case .failure(let error):
                    print("Failed to load image: \(error)")
                }
            }
            return
        }
        imageUser(image)
    }
}

