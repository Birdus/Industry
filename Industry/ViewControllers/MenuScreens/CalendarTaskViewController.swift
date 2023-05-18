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

class CalendarTaskViewController: UIViewController {
    // MARK: - Private UI
    /// List of issue tasks
    private var issues: [Issues]!
    /// Employee details
    private var employee: Employee!
    
    /// The calendar view.
    lazy private var calendareTask: FSCalendar = {
        var calendar: FSCalendar = FSCalendar()
        calendar.scope = .week
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.allowsMultipleSelection = false
        calendar.select(nil)
        return calendar
    }()
    
    /// UITableView for displaying tasks
    private lazy var tblListCalendar: UITableView = {
        let tableView = UITableView()
        tableView.register(ListCaledarTblViewCell.self, forCellReuseIdentifier: ListCaledarTblViewCell.indificatorCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    /// The reload button for reloading the calendar.
    private lazy var btnReloadTask: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "🔃", style: UIBarButtonItem.Style.done, target: self, action: #selector(btnReloadTask_Click))
        btn.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.monospacedDigitSystemFont(ofSize: CGFloat(UIScreen.main.bounds.width/8)/2, weight: .bold),
        ], for: .normal)
        return btn
    }()
    
    /// The add task button for adding tasks to the calendar.
    private lazy var btnAddTask: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "➕", style: UIBarButtonItem.Style.done, target: self, action: #selector(btnAddTask_Click))
        btn.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.monospacedDigitSystemFont(ofSize: CGFloat(UIScreen.main.bounds.width/8)/2, weight: .bold),
        ], for: .normal)
        return btn
    }()
    
    
    private lazy var calendareHeightConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: calendareTask, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        return constraint
    }()
    
    private lazy var swipeUpCalendare: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipecalendareTask_Swipe))
        swipe.direction = .up
        return swipe
    }()
    
    private lazy var swipeDownCalendare: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipecalendareTask_Swipe))
        swipe.direction = .down
        return swipe
    }()
    
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    deinit {
        calendareTask.removeGestureRecognizer(swipeUpCalendare)
        calendareTask.removeGestureRecognizer(swipeDownCalendare)
    }
    
    // MARK: - Action
    /// Handler for the add task and reload buttons.
    @objc
    private func btnAddTask_Click(_ sender: UIBarButtonItem) {
        // TODO: Implement add task and reload functionality
    }
    
    /// Handler for the  reload button.
    @objc
    private func btnReloadTask_Click(_ sender: UIBarButtonItem) {
        let apiManagerIndustry: APIManagerIndustry = APIManagerIndustry()
        let blurEffectView = setupBlurEffectView(style: .light, alpha: 0.6)
        let activityIndicator = setupActivityIndicator(in: blurEffectView.contentView, style: .gray)
        apiManagerIndustry.fetch(request: ForecastType.EmployeeWitchId(id: employee.id), HTTPMethod: .get) { (json: [String: Any]) -> Employee? in
            return Employee.decodeJSON(json: json)
        } completionHandler: { [weak self] (result: APIResult<Employee?>) in
            guard let self = self else { return }
            switch result {
            case .success(let employees):
                guard let employees = employees else {
                    print("Failed to parse employees.")
                    return
                }
                self.employee = employees
                guard let idLaborCosts = employees.laborCosts?.compactMap({ $0.issueId }) else { return }
                apiManagerIndustry.fetchIssues(HTTPMethod: .get, ids: idLaborCosts) { (json: [String: Any]) -> Issues? in
                    return Issues.decodeJSON(json: json)
                } completionHandler: { [weak self] (result: APIResult<[Issues]>) in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let issues):
                        self.issues = issues
                        DispatchQueue.main.async {
                            self.tblListCalendar.reloadData()
                            self.calendareTask.reloadData()
                            activityIndicator.stopAnimating()
                            blurEffectView.removeFromSuperview()
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    case .successArray(_):
                        print("Expected single objects, but got array.")
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            case .successArray(_):
                print("Expected single object, but got array.")
            }
        }
    }
    
    @objc
    private func swipecalendareTask_Swipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up:
            if calendareTask.scope == .month {
                calendareTask.setScope(.week, animated: true)
            } else {
                return
            }
        case .down:
            if calendareTask.scope == .month {
                return
            } else {
                calendareTask.setScope(.month, animated: true)
            }
        default:
            break
        }
    }
    
    // MARK: - Private func
    
    private func setupBlurEffectView(style: UIBlurEffect.Style, alpha: CGFloat) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = alpha
        view.addSubview(blurEffectView)
        return blurEffectView
    }
    
    private func setupActivityIndicator(in view: UIView, style: UIActivityIndicatorView.Style) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        return activityIndicator
    }
    
    /// Configures the UI elements of the view controller.
    private func configureUI() {
        view.addSubview(calendareTask)
        view.addSubview(tblListCalendar)
        navigationItem.rightBarButtonItem = btnAddTask
        navigationItem.leftBarButtonItem = btnReloadTask
        calendareTask.addGestureRecognizer(swipeUpCalendare)
        calendareTask.addGestureRecognizer(swipeDownCalendare)
        view.backgroundColor = .white
        calendareTask.addConstraint(calendareHeightConstraint)
        calendareTask.delegate = self
        calendareTask.dataSource = self
        NSLayoutConstraint.activate([
            // Constraints for the calendar
            calendareTask.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendareTask.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            calendareTask.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            // Constraints for the calendar list table
            tblListCalendar.topAnchor.constraint(equalTo: calendareTask.bottomAnchor, constant: 5),
            tblListCalendar.leadingAnchor.constraint(equalTo: calendareTask.leadingAnchor),
            tblListCalendar.trailingAnchor.constraint(equalTo: calendareTask.trailingAnchor),
            tblListCalendar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
}

// MARK: - FSCalendarDelegate
extension CalendarTaskViewController: FSCalendarDelegate {
    
    /// Handler for when a user selects a date on the calendar.
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY"
        let str = formatter.string(from: date)
        print("\(str)")
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendareHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
}

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

extension CalendarTaskViewController: FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .white
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .black
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
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
                    if days < 0 {
                        return .black
                    } else if days < 7 {
                        return .black
                    } else {
                        return .black
                    }
                }
            }
        }
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}

extension CalendarTaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Передать задачу".localized
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Завершить задачу".localized, handler: { (action, view, completionHandler) in
            let blurEffectView = self.setupBlurEffectView(style: .light, alpha: 0.6)
            let activityIndicator = self.setupActivityIndicator(in: blurEffectView.contentView, style: .gray)
            let itemToDelete = self.issues[indexPath.row]
            let apiManager = APIManagerIndustry()
            apiManager.deleteItem(request: ForecastType.IssueWithId(id: itemToDelete.id)) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        let issueToDelete = self.issues[indexPath.row]
                        if let index = self.employee.laborCosts?.firstIndex(where: { $0.issueId == issueToDelete.id }) {
                            self.employee.laborCosts?.remove(at: index)
                        }
                        self.issues.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        self.tblListCalendar.reloadData()
                        self.calendareTask.reloadData()
                        activityIndicator.stopAnimating()
                        blurEffectView.removeFromSuperview()
                    }
                    
                case .failure(let error):
                    // Обработка ошибки
                    print("Error deleting item: \(error)")
                case .successArray(_):
                    print("Expected single object, but got array.")
                }
            }
            completionHandler(true)
        })
        action.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}

extension CalendarTaskViewController: TabBarControllerDelegate {
    func tabBarController(_ tabBarController: TabBarController, didSelectTabAtIndex index: Int, issues datas: [Issues], employee data: Employee) {
        employee = data
        issues = datas
    }
}
