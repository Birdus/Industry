//
//  SelectionListEmployeeViewController.swift
//  Industry
//
//  Created by  Даниил on 25.05.2023.
//

import UIKit

class SelectionListEmployeeViewController: UIViewController {
    
    private var employees: [Employee]!
    
    // MARK: - Private UI
    private lazy var tblEmployee: UITableView = {
        let tableView = UITableView()
        tableView.register(ListEmployeesTblViewCell.self, forCellReuseIdentifier: ListEmployeesTblViewCell.indificatorCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.accessibilityIdentifier = "tblEmployee"
        return tableView
    }()
    
    // Back button
    private lazy var btnBack: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "✖️", style: .plain, target: self, action: #selector(btnBack_Click))
        btn.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.monospacedDigitSystemFont(ofSize: CGFloat(UIScreen.main.bounds.width/8)/2, weight: .bold),
        ], for: .normal)
        btn.accessibilityIdentifier = "btnBack"
        return btn
    }()
    
    private lazy var btnSave: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(btnBack_Click))
        btn.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.monospacedDigitSystemFont(ofSize: CGFloat(UIScreen.main.bounds.width/8)/2.5, weight: .bold),
        ], for: .normal)
        btn.accessibilityIdentifier = "btnBack"
        return btn
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @objc
    private func btnBack_Click(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Private func
    private func configureUI() {
        self.navigationItem.rightBarButtonItem = btnSave
        self.navigationItem.leftBarButtonItem = btnBack
        self.view.backgroundColor = .white
        self.view.addSubview(tblEmployee)
        NSLayoutConstraint.activate([
            tblEmployee.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tblEmployee.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tblEmployee.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            tblEmployee.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
    }
}

extension SelectionListEmployeeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListEmployeesTblViewCell.indificatorCell, for: indexPath) as? ListEmployeesTblViewCell else {
            fatalError("Unable to dequeue HeadMenuTableViewCell.")
        }
        cell.fillTable(fullName: "\(employees[indexPath.row].lastName) \(employees[indexPath.row].firstName) \(employees[indexPath.row].secondName)")
        cell.selectionStyle = .none
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
}

extension SelectionListEmployeeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height/9
    }
}

extension SelectionListEmployeeViewController: NewTaskViewControllerDelegate {
    func newTaskViewController(_ viewController: NewTaskViewController, didLoad values: [Employee]) {
        DispatchQueue.main.async {
            self.employees = values
            self.tblEmployee.reloadData()
        }
        
    }
}
