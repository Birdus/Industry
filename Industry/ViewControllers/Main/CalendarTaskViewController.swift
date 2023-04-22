//
//  CalendarTaskViewController.swift
//  Industry
//
//  Created by Birdus on 05.04.2023.
//

import UIKit
import FSCalendar

class CalendarTaskViewController: UIViewController {
    
    lazy private var calendareTask: FSCalendar = FSCalendar()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.addSubview(calendareTask)
        self.view.backgroundColor = .white
        calendareTask.delegate = self
        calendareTask.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height/1.2)
        calendareTask.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        calendareTask.translatesAutoresizingMaskIntoConstraints = false
        calendareTask.allowsMultipleSelection = true;
    }
}

extension CalendarTaskViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY"
        let str = formatter.string(from: date)
        print("\(str)")
    }
}
