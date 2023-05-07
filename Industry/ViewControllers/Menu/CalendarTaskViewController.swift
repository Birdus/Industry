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
 
 swift
 Copy code
 
 - Note: This view controller assumes that the user has already logged in and has access to the necessary data.
 */

import UIKit
import FSCalendar

class CalendarTaskViewController: UIViewController {
    // MARK: - Private UI
    /// The calendar view.
    lazy private var calendareTask: FSCalendar = FSCalendar()
    
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
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
    
    // MARK: - Private func
    /// Configures the UI elements of the view controller.
    private func configureUI() {
        view.addSubview(calendareTask)
        self.navigationItem.rightBarButtonItem = btnAddTask
        self.navigationItem.leftBarButtonItem = btnReloadTask
        self.view.backgroundColor = .white
        calendareTask.delegate = self
        NSLayoutConstraint.activate([
            calendareTask.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendareTask.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendareTask.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendareTask.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
        calendareTask.translatesAutoresizingMaskIntoConstraints = false
        calendareTask.allowsMultipleSelection = true
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
}
