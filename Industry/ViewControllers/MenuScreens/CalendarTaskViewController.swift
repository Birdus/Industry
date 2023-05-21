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

// MARK: - MenuTabBarControllerDelegate
protocol CalendarTaskViewControllerDelegate: AnyObject {
    /**
     Called when a  CalendarTaskViewController change data .
     
     - Parameters:
     - viewController: The calendar view controller.
     - witchId: The id where deleate data.
     */
    func calendarTaskViewController(_ viewController: UIViewController, didDeleateData witchId: Int)
    
    /**
     Called when a  CalendarTaskViewController  need to action to Ui and data .
     
     - Parameters:
     - viewController: The calendar view controller.
     */
    func calendarTaskViewController(_ viewController: UIViewController)
}

class CalendarTaskViewController: UIViewController {
    // MARK: - Properties
    /// List of issue tasks
    private var issues: [Issues]!
    /// Employee details
    private var employee: Employee!
    /// Delegate view controller
    weak var delegete: CalendarTaskViewControllerDelegate?
    
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
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    deinit {
        clnEvent.removeGestureRecognizer(swipeUpCalendare)
        clnEvent.removeGestureRecognizer(swipeDownCalendare)
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
    /// Configures the UI elements of the view controller.
    private func configureUI() {
        view.addSubview(clnEvent)
        view.addSubview(tblListCalendar)
        navigationItem.rightBarButtonItem = btnAddTask
        navigationItem.leftBarButtonItem = btnReloadTask
        clnEvent.addGestureRecognizer(swipeUpCalendare)
        clnEvent.addGestureRecognizer(swipeDownCalendare)
        view.backgroundColor = .white
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
            tblListCalendar.leadingAnchor.constraint(equalTo: clnEvent.leadingAnchor),
            tblListCalendar.trailingAnchor.constraint(equalTo: clnEvent.trailingAnchor),
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
}

// MARK: - UITableViewDelegate
extension CalendarTaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Передать задачу".localized
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Завершить задачу".localized, handler: { (action, view, completionHandler) in
            let issueToDelete = self.issues[indexPath.row]
            self.delegete?.calendarTaskViewController(self, didDeleateData: issueToDelete.id)
        })
        action.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
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
