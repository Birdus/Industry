//
//  CalendarTaskViewController.swift
//  Industry
//
//  Created by Birdus on 05.04.2023.
//

/**
 A view controller that displays a calendar and allows users to add and view tasks for selected dates.
 
 - Author: Daniil
 - Date: 05.04.2023
 - Version: 1.0
 
 ## Important Notes ##
 1. This view controller uses the FSCalendar library to display a calendar.
 2. Users can add tasks by tapping the "+" button in the navigation bar.
 3. Users can reload the calendar by tapping the "🔃" button in the navigation bar.
 
 ## Example Usage ##
 let calendarTaskVC = CalendarTaskViewController()
 self.navigationController?.pushViewController(calendarTaskVC, animated: true)
 
 - Note: This view controller assumes that the user has already logged in and has access to the necessary data.
 */

import UIKit
import FSCalendar
import UserNotifications

// MARK: - MenuTabBarControllerDelegate
protocol CalendarTaskViewControllerDelegate: AnyObject {
    /**
     Called when a  CalendarTaskViewController change data .
     
     - Parameters:
     - viewController: The calendar view controller.
     - witchId: The id where deleate data.
     */
    func calendarTaskViewController(_ viewController: CalendarTaskViewController, didDeleateData witchId: Int)
    
    /**
     Called when a  CalendarTaskViewController  need to action to Ui and data .
     
     - Parameters:
     - viewController: The calendar view controller.
     */
    func calendarTaskViewController(_ viewController: CalendarTaskViewController)
    
    func calendarTaskViewController(_ viewController: CalendarTaskViewController, didLoadEmployees: [Employee], isues: Issues, laborCoast: LaborCost, project: Project)
    
}

class CalendarTaskViewController: UIViewController {
    // MARK: - Properties
    /// List of issue tasks
    private var issues: [Issues]!
    /// Employee details
    private var employee: Employee!
    /// Delegate view controller
    weak var delegete: CalendarTaskViewControllerDelegate!
    
    // MARK: - Private UI
    /// The calendar view.
    lazy private var clnEvent: FSCalendar = {
        var calendar: FSCalendar = FSCalendar()
        calendar.scope = .week
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.allowsMultipleSelection = false
        calendar.select(nil)
        calendar.accessibilityIdentifier = "clnEvent"
        return calendar
    }()
    
    /// UITableView for displaying tasks
    private lazy var tblListCalendar: UITableView = {
        let tableView = UITableView()
        tableView.register(ListCaledarTblViewCell.self, forCellReuseIdentifier: ListCaledarTblViewCell.indificatorCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let color = UIColor(red: 0.157, green: 0.535, blue: 0.821, alpha: 0.8)
        tableView.clipsToBounds = true
        tableView.backgroundColor = .white
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.layer.cornerRadius = 10.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.accessibilityIdentifier = "tblListCalendar"
        return tableView
    }()
    
    /// The reload button for reloading the calendar.
    private lazy var btnReloadTask: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "↻", style: .plain, target: self, action: #selector(btnReloadTask_Click))
        btn.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.monospacedDigitSystemFont(ofSize: CGFloat(UIScreen.main.bounds.width/8)/2, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor(ciColor: .black)
        ], for: .normal)
        return btn
    }()
    
    /// The add task button for adding tasks to the calendar.
    private lazy var btnAddTask: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "+", style: UIBarButtonItem.Style.done, target: self, action: #selector(btnAddTask_Click))
        btn.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.monospacedDigitSystemFont(ofSize: CGFloat(UIScreen.main.bounds.width/8)/1.5, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor(ciColor: .black)
        ], for: .normal)
        return btn
    }()
    
    /// The add task button for adding tasks to the calendar.
    private lazy var clnHeightConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: clnEvent, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        return constraint
    }()
    
    /// The gesture recognizer for swipe up and change type  month calendar.
    private lazy var swipeUpCalendare: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipecalendareTask_Swipe))
        swipe.direction = .up
        return swipe
    }()
    
    /// The gesture recognizer for swipe up and change type weak calendar.
    private lazy var swipeDownCalendare: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipecalendareTask_Swipe))
        swipe.direction = .down
        return swipe
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        return activityIndicator
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.6
        return blurEffectView
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async{
            self.notificationTask()
        }
        configureUI()
    }
    
    deinit {
        clnEvent.removeGestureRecognizer(swipeUpCalendare)
        clnEvent.removeGestureRecognizer(swipeDownCalendare)
        print("sucsses closed CalendarTaskViewController")
    }
    
    // MARK: - Action
    /// Handler for the add task and reload buttons.
    @objc
    private func btnAddTask_Click(_ sender: UIBarButtonItem) {
        let vc = NewTaskViewController()
        vc.delegete = self
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    /// Handler for the  reload button.
    @objc
    private func btnReloadTask_Click(_ sender: UIBarButtonItem) {
        delegete?.calendarTaskViewController(self)
    }
    
    /// Handler for swipe calendare.
    @objc
    private func swipecalendareTask_Swipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up:
            if clnEvent.scope == .month {
                clnEvent.setScope(.week, animated: true)
            } else {
                return
            }
        case .down:
            if clnEvent.scope == .month {
                return
            } else {
                clnEvent.setScope(.month, animated: true)
            }
        default:
            break
        }
    }
    
    // MARK: - Private func
    private func isViewLoad(_ isShow: Bool) {
        if isShow {
            blurEffectView.contentView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            self.view.addSubview(blurEffectView)
        } else {
            activityIndicator.stopAnimating()
            blurEffectView.removeFromSuperview()
        }
    }
    
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
    
    private func notificationTask() {
        guard let dates = employee.laborCosts?.map({ $0.date }) else { return }
        let notificationCenter = UNUserNotificationCenter.current()
        for (index, taskDate) in dates.enumerated() {
            guard let idIssues = issues[index].id else { continue }
            let calendar = Calendar.current
            guard let oneDayBefore = calendar.date(byAdding: .day, value: -1, to: taskDate) else { continue }
            notificationCenter.getPendingNotificationRequests { (requests) in
                let taskNotifications = requests.filter { $0.identifier.hasPrefix("task-\(idIssues)-oneDayBefore") }
                if taskNotifications.isEmpty {
                    let contentOneDayBefore = UNMutableNotificationContent()
                    var text = "Дедлайн задачи ".localized
                    text += self.issues[index].taskName
                    text = " через один день".localized
                    contentOneDayBefore.title = text
                    contentOneDayBefore.body = "У вас есть один день, чтобы завершить задачу".localized
                    contentOneDayBefore.sound = UNNotificationSound.default
                    var dateComponentsMorning = calendar.dateComponents([.year, .month, .day], from: oneDayBefore)
                    dateComponentsMorning.hour = 9
                    dateComponentsMorning.minute = 0
                    var dateComponentsAfternoon = calendar.dateComponents([.year, .month, .day], from: oneDayBefore)
                    dateComponentsAfternoon.hour = 15
                    dateComponentsAfternoon.minute = 0
                    let triggerMorning = UNCalendarNotificationTrigger(dateMatching: dateComponentsMorning, repeats: false)
                    let triggerAfternoon = UNCalendarNotificationTrigger(dateMatching: dateComponentsAfternoon, repeats: false)
                    let requestMorning = UNNotificationRequest(identifier: "task-\(idIssues)-oneDayBefore-morning", content: contentOneDayBefore, trigger: triggerMorning)
                    let requestAfternoon = UNNotificationRequest(identifier: "task-\(idIssues)-oneDayBefore-afternoon", content: contentOneDayBefore, trigger: triggerAfternoon)
                    notificationCenter.add(requestMorning)
                    notificationCenter.add(requestAfternoon)
                }
            }
        }
    }
    
    /// Configures the UI elements of the view controller.
    private func configureUI() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barStyle = .default
        navigationItem.rightBarButtonItem = btnAddTask
        navigationItem.leftBarButtonItem = btnReloadTask
        navigationItem.title = "Ближайщие события".localized
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 17.0, weight: .regular)
        ]
        tabBarController?.tabBar.barTintColor = .white
        tabBarController?.tabBar.barStyle = .blackOpaque
        view.addSubview(clnEvent)
        view.addSubview(tblListCalendar)
        view.backgroundColor = .white
        clnEvent.addGestureRecognizer(swipeUpCalendare)
        clnEvent.addGestureRecognizer(swipeDownCalendare)
        clnEvent.addConstraint(clnHeightConstraint)
        clnEvent.delegate = self
        clnEvent.dataSource = self
        NSLayoutConstraint.activate([
            // Constraints for the calendar
            clnEvent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            clnEvent.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            clnEvent.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            // Constraints for the calendar list table
            tblListCalendar.topAnchor.constraint(equalTo: clnEvent.bottomAnchor, constant: 5),
            tblListCalendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            tblListCalendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            tblListCalendar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(self.tabBarController?.tabBar.frame.height ?? 0) - 5)
            
            
        ])
    }
}

// MARK: - FSCalendarDelegate
extension CalendarTaskViewController: FSCalendarDelegate {
    /// Handler for when a user selects a date on the calendar.
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        isViewLoad(true)
        let selectedDates = employee.laborCosts?.filter ({
            let calendar = Calendar.current
            let componentsSelf = calendar.dateComponents([.year, .month, .day], from: $0.date)
            let componentsDate = calendar.dateComponents([.year, .month, .day], from: date)
            return componentsSelf.month == componentsDate.month && componentsSelf.day == componentsDate.day
        })
        
        let isuses = issues.first(where: {selectedDates?.first?.issueId == $0.id})
        if let selectedDate = selectedDates?.first,
           let isuses = isuses{
            let apiManager = APIManagerIndustry()
            apiManager.fetch(request: ForecastType.ProjectWitchId(id: isuses.projectId), parse: { (json) -> Project? in
                return Project.decodeJSON(json: json)
            }, completionHandler: { (result: APIResult<Project>) in
                switch result {
                case .success(let project):
                        apiManager.fetch(request: ForecastType.Employee, parse: { (json) -> [Employee]? in
                            return json.compactMap({Employee.decodeJSON(json: $0)})
                        }, completionHandler: { (result: APIResult<Employee>) in
                            switch result {
                            case .success(_):
                                DispatchQueue.main.async {
                                    self.showAlController(message: INDNetworkingError.decodingFailed.errorMessage)
                                }
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    let errorsUser = INDNetworkingError.init(error)
                                    self.showAlController(message: errorsUser.errorMessage)
                                }
                            case .successArray(let employees):
                                DispatchQueue.main.async {
                                self.isViewLoad(false)
                                let vc = NewTaskViewController()
                                self.delegete = vc
                                vc.delegete = self
                                self.delegete.calendarTaskViewController(self, didLoadEmployees: employees, isues: isuses, laborCoast: selectedDate, project: project)
                                vc.modalPresentationStyle = .custom
                                vc.transitioningDelegate = self
                                self.present(vc, animated: true, completion: nil)
                                }
                            }
                        })
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.isViewLoad(false)
                        let errorsUser = INDNetworkingError.init(error)
                        self.showAlController(message: errorsUser.errorMessage)
                    }
                case .successArray(_):
                    DispatchQueue.main.async {
                        self.isViewLoad(false)
                        self.showAlController(message: INDNetworkingError.decodingFailed.errorMessage)
                    }
                }
            })
        } else {
            isViewLoad(false)
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        clnHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
}

// MARK: - FSCalendarDataSource
extension CalendarTaskViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        guard let laborCosts = employee.laborCosts else { return 0 }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        for laborCost in laborCosts {
            if formatter.string(from: laborCost.date) == dateString {
                return 1
            }
        }
        return 0
    }
}

// MARK: - FSCalendarDelegateAppearance
extension CalendarTaskViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .white
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .black
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return .black
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        guard let laborCosts = employee.laborCosts else { return .white }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = formatter.string(from: Date())
        let currentDate = formatter.date(from: currentDateString)!
        let dateString = formatter.string(from: date)
        let calendar = Calendar.current
        for laborCost in laborCosts {
            if formatter.string(from: laborCost.date) == dateString {
                let laborCostDate = formatter.date(from: formatter.string(from: laborCost.date))!
                let components = calendar.dateComponents([.day], from: currentDate, to: laborCostDate)
                if let days = components.day {
                    if days <= 0 {
                        return .red
                    } else if days < 7 {
                        return .yellow
                    } else {
                        return .green
                    }
                }
            }
        }
        return .white
    }
}

// MARK: - UITableViewDataSource
extension CalendarTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCaledarTblViewCell.indificatorCell, for: indexPath) as? ListCaledarTblViewCell else {
            fatalError("Unable to dequeue cell.")
        }
        cell.fiillTable(issues[indexPath.row].taskName, issues[indexPath.row].taskDiscribe, employee.laborCosts?[indexPath.row].date)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isViewLoad(true)
        let selectedDates = employee.laborCosts?[indexPath.row]
        let isuses = issues.first(where: {selectedDates?.issueId == $0.id})
        if let selectedDate = selectedDates,
           let isuses = isuses{
            let apiManager = APIManagerIndustry()
            apiManager.fetch(request: ForecastType.ProjectWitchId(id: isuses.projectId), parse: { (json) -> Project? in
                return Project.decodeJSON(json: json)
            }, completionHandler: { (result: APIResult<Project>) in
                switch result {
                case .success(let project):
                    apiManager.fetch(request: ForecastType.Employee, parse: { (json) -> [Employee]? in
                        return json.compactMap({Employee.decodeJSON(json: $0)})
                    }, completionHandler: { (result: APIResult<Employee>) in
                        switch result {
                        case .success(_):
                            DispatchQueue.main.async {
                                self.showAlController(message: INDNetworkingError.decodingFailed.errorMessage)
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                let errorsUser = INDNetworkingError.init(error)
                                self.showAlController(message: errorsUser.errorMessage)
                            }
                        case .successArray(let employees):
                            DispatchQueue.main.async {
                            self.isViewLoad(false)
                            let vc = NewTaskViewController()
                            self.delegete = vc
                            vc.delegete = self
                            self.delegete.calendarTaskViewController(self, didLoadEmployees: employees, isues: isuses, laborCoast: selectedDate, project: project)
                            vc.modalPresentationStyle = .custom
                            vc.transitioningDelegate = self
                            self.present(vc, animated: true, completion: nil)
                            }
                        }
                    })
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.isViewLoad(false)
                        let errorsUser = INDNetworkingError.init(error)
                        self.showAlController(message: errorsUser.errorMessage)
                    }
                case .successArray(_):
                    DispatchQueue.main.async {
                        self.isViewLoad(false)
                        self.showAlController(message: "Error this array object")
                    }
                }
            })
        } else {
            isViewLoad(false)
        }
    }
}

// MARK: - UITableViewDelegate
extension CalendarTaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Передать задачу".localized
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Завершить задачу".localized, handler: { (action, view, completionHandler) in
            let issueToDelete = self.issues[indexPath.row]
            guard let idIssues = issueToDelete.id else {return}
            
            // Удаление уведомления
            let notificationCenter = UNUserNotificationCenter.current()
            let identifiers = ["task-\(idIssues)-oneDayBefore-morning", "task-\(idIssues)-oneDayBefore-afternoon"]
            notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
            
            self.delegete?.calendarTaskViewController(self, didDeleateData: idIssues)
        })
        action.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height/9.5
    }
}

// MARK: - TabBarControllerDelegate
extension CalendarTaskViewController: TabBarControllerDelegate {
    func tabBarController(_ tabBarController: TabBarController, didSelectTabAtIndex index: Int, issues datas: [Issues], employee data: Employee) {
        employee = data
        issues = datas
        tblListCalendar.reloadData()
        clnEvent.reloadData()
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension CalendarTaskViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - NewTaskViewControllerDelegate
extension CalendarTaskViewController: NewTaskViewControllerDelegate {
    func newTaskViewController(_ viewController: NewTaskViewController, didLoad values: [Employee], selected employees: [Employee]?) {
        return
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, isChande values: Bool) {
        if values {
            self.delegete?.calendarTaskViewController(self)
        }
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, didClosed: Bool) {
        return
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, didLoad values: [Project]) {
        return
    }
    
}
