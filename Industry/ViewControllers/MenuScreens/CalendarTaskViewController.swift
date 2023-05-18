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
    private var issues: [Issues]!
    private var employee: Employee!
    
    /// The calendar view.
    lazy private var calendareTask: FSCalendar = {
        var calendar: FSCalendar = FSCalendar()
        calendar.scope = .week
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.delegate = self
        return calendar
    }()
    
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
        // TODO: Implement add task and reload functionality
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

extension CalendarTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.capacity
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
}

extension CalendarTaskViewController: UITableViewDelegate {
    
}

extension CalendarTaskViewController: TabBarControllerDelegate {
    func tabBarController(_ tabBarController: TabBarController, didSelectTabAtIndex index: Int, issues datas: [Issues], employee data: Employee) {
        employee = data
        issues = datas
    }
}



