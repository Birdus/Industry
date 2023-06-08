//
//  SelectionListEmployeeViewController.swift
//  Industry
//
//  Created by  Даниил on 25.05.2023.
//

import UIKit

protocol SelectionListViewControllerDelegete: AnyObject {
    func selectionListViewController(_ cell: SelectionListViewController, didSelected value: [Employee])
    func selectionListViewController(_ cell: SelectionListViewController, didSelected value: Project)
}

class SelectionListViewController: UIViewController {
    
    private var employees: [Employee]?
    private var includeEmploye : [Employee]?
    private var project: [Project]?
    private var includedData: [Int : Bool]?
    public var delegete: SelectionListViewControllerDelegete!
    
    // MARK: - Private UI
    private lazy var tblList: UITableView = {
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
        let btn = UIBarButtonItem(title: "Сохранить".localized, style: .plain, target: self, action: #selector(btnSave_Click))
        btn.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.monospacedDigitSystemFont(ofSize: CGFloat(UIScreen.main.bounds.width/8)/2.5, weight: .bold),
        ], for: .normal)
        btn.accessibilityIdentifier = "btnSave"
        return btn
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    deinit {
        print("sucsses closed SelectionListViewController")
    }
    
    @objc
    private func btnSave_Click(_ sender: UIBarButtonItem) {
        if let employee = employees {
            guard let includedEmployees = includedData else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            var selectedEmployees: [Employee] = []
            for (employeeId, isIncluded) in includedEmployees {
                if isIncluded, let employee = employee.first(where: { $0.id == employeeId }) {
                    selectedEmployees.append(employee)
                }
            }
            delegete.selectionListViewController(self, didSelected: selectedEmployees)
            self.dismiss(animated: true, completion: nil)
        } else if let project = project {
            guard let includedProject = includedData else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            for (employeeId, isIncluded) in includedProject {
                if isIncluded, let employee = project.first(where: { $0.id == employeeId }) {
                    let selectedProject = employee
                    delegete.selectionListViewController(self, didSelected: selectedProject)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    private func btnBack_Click(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private func
    private func configureUI() {
        includedData = [:]
        self.navigationItem.rightBarButtonItem = btnSave
        self.navigationItem.leftBarButtonItem = btnBack
        self.view.backgroundColor = .white
        self.view.addSubview(tblList)
        NSLayoutConstraint.activate([
            tblList.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tblList.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tblList.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            tblList.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
    }
}

extension SelectionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let employee = employees {
            return employee.count
        } else if let project = project {
            return project.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListEmployeesTblViewCell.indificatorCell, for: indexPath) as? ListEmployeesTblViewCell else {
            fatalError("Unable to dequeue HeadMenuTableViewCell.")
        }
        if let employee = employees {
            if let selectedEmployee = includeEmploye {
                cell.fillTable(employee: "\(employee[indexPath.row].lastName) \(employee[indexPath.row].firstName) \(employee[indexPath.row].secondName)", employee: employee[indexPath.row].id, isInclude: employee[indexPath.row].id == selectedEmployee[indexPath.row].id )
            } else {
                cell.fillTable(employee: "\(employee[indexPath.row].lastName) \(employee[indexPath.row].firstName) \(employee[indexPath.row].secondName)", employee: employee[indexPath.row].id, isInclude: false)
            }
            
        } else if let project = project {
            cell.fillTable(employee: "\(project[indexPath.row].projectName)", employee: project[indexPath.row].id, isInclude: false)
        }
        cell.selectionStyle = .none
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.delegete = self
        return cell
    }
}

extension SelectionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height/9
    }
}

extension SelectionListViewController: NewTaskViewControllerDelegate {
    func newTaskViewController(_ viewController: NewTaskViewController, didLoad values: [Employee], selected employees: [Employee]?) {
        DispatchQueue.main.async {
            self.employees = values
            self.includeEmploye = employees
            self.tblList.reloadData()
        }
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, isChande values: Bool) {
        return
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, didClosed: Bool) {
        return
    }
    
    func newTaskViewController(_ viewController: NewTaskViewController, didLoad values: [Project]) {
        DispatchQueue.main.async {
            self.project = values
            
            self.tblList.reloadData()
        }
    }
}

extension SelectionListViewController: ListEmployeesTblViewCellDelegete {
    func listEmployeesTblViewCell(_ cell: ListEmployeesTblViewCell, didSelected employeeId: Int, isEnclude task: Bool) {
        includedData?[employeeId] = task
        if employees != nil {
            return
        } else if let project = project {
            guard let includedProject = includedData else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            for (employeeId, isIncluded) in includedProject {
                if isIncluded, let employee = project.first(where: { $0.id == employeeId }) {
                    let selectedProject = employee
                    delegete.selectionListViewController(self, didSelected: selectedProject)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
