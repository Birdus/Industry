//
//  NewTaskViewController.swift
//  Industry
//
//  Created by  Даниил on 22.05.2023.
//

import UIKit

// MARK: - NewTaskViewControllerDelegate
protocol NewTaskViewControllerDelegate: AnyObject {
    func newTaskViewController(_ viewController: NewTaskViewController, didLoad values: [Employee], selected employees: [Employee]?)
    func newTaskViewController(_ viewController: NewTaskViewController, didLoad values: [Project])
    func newTaskViewController(_ viewController: NewTaskViewController, isChande values: Bool)
    func newTaskViewController(_ viewController: NewTaskViewController, didClosed: Bool)
}

class NewTaskViewController: UIViewController {
    // MARK: - Properti
    private var originYView: CGRect = CGRect()
    weak var delegete: NewTaskViewControllerDelegate!
    private var apiManagerIndustry: APIManagerIndustry!
    private var employees: [Employee]?
    private var issues: Issues?
    private var laborCoast: LaborCost?
    private var project: Project?
    private var isChande: Bool?
    
    // MARK: - Private UI
    private lazy var tblNewTask: UITableView = {
        let tableView = UITableView()
        tableView.register(EditNameDiscribeTaskTblViewCell.self, forCellReuseIdentifier: EditNameDiscribeTaskTblViewCell.indificatorCell)
        tableView.register(EditHourTaskTblViewCell.self, forCellReuseIdentifier: EditHourTaskTblViewCell.indificatorCell)
        tableView.register(EditEmployeeAndTaskTaskTblViewCell.self, forCellReuseIdentifier: EditEmployeeAndTaskTaskTblViewCell.indificatorCell)
        tableView.register(EditDateTaskTblViewCell.self, forCellReuseIdentifier: EditDateTaskTblViewCell.indificatorCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorColor = .white
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(red: 0.157, green: 0.535, blue: 0.821, alpha: 1)
        tableView.accessibilityIdentifier = "tblNewTask"
        return tableView
    }()
    
    private lazy var btnCreate: UIButton = {
        let btn = UIButton()
        btn.accessibilityIdentifier = "btnSave"
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        btn.clipsToBounds = false
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btn.layer.shadowOpacity = 0.8
        btn.layer.shadowRadius = 0.4
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.masksToBounds = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        if self.isChande == true {
            btn.addTarget(self, action: #selector(btnChange_Click), for: .touchUpInside)
            btn.setTitle("Изменить".localized, for: .normal)
        } else {
            btn.addTarget(self, action: #selector(btnCreate_Click), for: .touchUpInside)
            btn.setTitle("Coхранить".localized, for: .normal)
        }
        return btn
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if issues == nil && laborCoast == nil {
            isChande = false
            issues = Issues(id: nil, taskName: "", projectId: 0, taskDiscribe: "")
            laborCoast = LaborCost(id: nil, date: Date(), employeeId: 0, issueId: 0, hourCount: 0)
        }
        apiManagerIndustry = APIManagerIndustry()
        registerForKeyboardNotification()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        originYView = view.frame
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        apiManagerIndustry = nil
    }
    
    // MARK: - Acrion
    
    @objc
    private func btnCreate_Click(_ notification: UIButton) {
        delegete.newTaskViewController(self, didClosed: true)
        
        let (activityIndicator, blurEffectView) = setupBlurAndActivityIndicator()
        
        guard let taskName = issues?.taskName, !taskName.isEmpty,
              let taskDiscribe = issues?.taskDiscribe, !taskDiscribe.isEmpty,
              laborCoast != nil,
              let hourCount = laborCoast?.hourCount, hourCount > 0,
              var laborCoasts = laborCoast,
              var isues = issues,
              let project = project,
              let employees = employees else {
            handleError(activityIndicator, blurEffectView, message: "Не удалось преобразовать данные".localized)
            return
        }
        
        isues.projectId = project.id
        apiManagerIndustry.post(request: ForecastType.Issue, data: isues) { result in
            switch result {
            case .success(let id):
                laborCoasts.issueId = id
                var successCounter = 0
                for employee in employees {
                    laborCoasts.employeeId = employee.id
                    self.apiManagerIndustry.post(request: ForecastType.LaborCost, data: laborCoasts) { result in
                        switch result {
                        case .success(_):
                            successCounter += 1
                            if successCounter == employees.count {
                                DispatchQueue.main.async {
                                    //                                    self.delegete.newTaskViewController(self, isChande: true)
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        case .failure(let error):
                            self.handleError(activityIndicator, blurEffectView, message: "Не удалось загрузить трудозатраты: \(error.localizedDescription)")
                        case .successArray(_):
                            self.handleError(activityIndicator, blurEffectView, message: "Unexpected response")
                        }
                    }
                }
            case .failure(let error):
                self.handleError(activityIndicator, blurEffectView, message: "Не удалось загрузить задачу: \(error.localizedDescription)")
            case .successArray(_):
                self.handleError(activityIndicator, blurEffectView, message: "Unexpected response")
            }
        }
    }
    
    @objc
    private func btnChange_Click(_ notification: UIButton) {
        delegete.newTaskViewController(self, didClosed: true)
        let (activityIndicator, blurEffectView) = setupBlurAndActivityIndicator()
        guard let taskName = issues?.taskName, !taskName.isEmpty,
              let taskDiscribe = issues?.taskDiscribe, !taskDiscribe.isEmpty,
              laborCoast != nil,
              let hourCount = laborCoast?.hourCount, hourCount > 0,
              var laborCoasts = laborCoast,
              var isues = issues,
              let project = project,
              let employees = employees else {
            handleError(activityIndicator, blurEffectView, message: "Не удалось преобразовать данные".localized)
            return
        }
        isues.projectId = project.id
        apiManagerIndustry.put(request: ForecastType.IssueWithId(id: isues.id ?? 0), data: isues) { result in
            switch result {
            case .success(_):
                for employee in employees  {
                    laborCoasts.employeeId = employee.id
                    self.apiManagerIndustry.put(request: ForecastType.LaborCostWitchId(id: laborCoasts.id ?? 0), data: laborCoasts) { result in
                        switch result {
                        case .success(_):
                            DispatchQueue.main.async {
                                //                                self.delegete.newTaskViewController(self, isChande: true)
                                self.dismiss(animated: true, completion: nil)
                            }
                        case .failure(let error):
                            self.handleError(activityIndicator, blurEffectView, message: "Не удалось обновить трудозатраты: \(error.localizedDescription)")
                        case .successArray(_):
                            self.handleError(activityIndicator, blurEffectView, message: "Unexpected response")
                        }
                    }
                }
            case .failure(let error):
                self.handleError(activityIndicator, blurEffectView, message: "Не удалось обновить задачу: \(error.localizedDescription)")
            case .successArray(_):
                self.handleError(activityIndicator, blurEffectView, message: "Unexpected response")
            }
        }
    }
    
    /// Keyboard will show notification handler
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let originYView = self.view.frame.origin.y
        let keyboardHeight = keyboardFrame.height
        let bottomSpace = view.frame.height - (tblNewTask.frame.origin.y + tblNewTask.frame.height)
        if originYView == self.originYView.origin.y {
            view.frame.origin.y -= max(0, keyboardHeight - bottomSpace - 25)
        } else {
            view.frame.origin.y = self.originYView.origin.y - max(0, keyboardHeight - bottomSpace - 25)
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = originYView.origin.y
    }
    
    // MARK: - Privates func
    /// Register for keyboard notifications
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupBlurAndActivityIndicator() -> (UIActivityIndicatorView, UIVisualEffectView) {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.6
        blurEffectView.contentView.addSubview(activityIndicator)
        view.addSubview(blurEffectView)
        return (activityIndicator, blurEffectView)
    }
    
    private func handleSucsess(_ activityIndicator: UIActivityIndicatorView, _ blurEffectView: UIVisualEffectView) {
        activityIndicator.stopAnimating()
        blurEffectView.removeFromSuperview()
    }
    
    private func handleError(_ activityIndicator: UIActivityIndicatorView, _ blurEffectView: UIVisualEffectView, message: String) {
        activityIndicator.stopAnimating()
        blurEffectView.removeFromSuperview()
        showAlController(message: message)
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
    
    private func loadEmployees(compleat: @escaping () -> Void) {
        if let employee = employees {
            apiManagerIndustry?.fetch(request: ForecastType.Employee, parse: { (json) -> [Employee]? in
                return json.compactMap({Employee.decodeJSON(json: $0)})
            }, completionHandler: { (result: APIResult<Employee>) in
                switch result {
                case .success(_):
                    print("Error this single object")
                    compleat()
                case .failure(let error):
                    print(error)
                    compleat()
                case .successArray(let employees):
                    self.delegete.newTaskViewController(self, didLoad: employees, selected: employee)
                    compleat()
                }
            })
        } else {
            apiManagerIndustry?.fetch(request: ForecastType.Employee, parse: { (json) -> [Employee]? in
                return json.compactMap({Employee.decodeJSON(json: $0)})
            }, completionHandler: { (result: APIResult<Employee>) in
                switch result {
                case .success(_):
                    print("Error this single object")
                    compleat()
                case .failure(let error):
                    print(error)
                    compleat()
                case .successArray(let employees):
                    self.delegete.newTaskViewController(self, didLoad: employees, selected: nil)
                    compleat()
                }
            })
        }
    }
    
    private func loadProject(compleat: @escaping () -> Void) {
        self.apiManagerIndustry?.fetch(request: ForecastType.Project, parse: { (json) -> [Project]? in
            return json.compactMap({Project.decodeJSON(json: $0)})
        }, completionHandler: { (result: APIResult<Project>) in
            switch result {
            case .success(_):
                print("Error this single object")
                compleat()
            case .failure(let error):
                print(error)
                compleat()
            case .successArray(let project):
                self.delegete.newTaskViewController(self, didLoad: project)
                compleat()
            }
        })
    }
    
    private func configureUI() {
        self.view.backgroundColor = UIColor(red: 0.157, green: 0.535, blue: 0.821, alpha: 1)
        self.view.addSubview(tblNewTask)
        self.view.addSubview(btnCreate)
        NSLayoutConstraint.activate([
            tblNewTask.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tblNewTask.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tblNewTask.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            
            btnCreate.topAnchor.constraint(equalTo: tblNewTask.bottomAnchor, constant: 5),
            btnCreate.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            btnCreate.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            btnCreate.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3)
        ])
    }
    
}

// MARK: - UITableViewDataSource
extension NewTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return self.view.bounds.height/5.5
        default:
            return self.view.bounds.height/7.5
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditNameDiscribeTaskTblViewCell.indificatorCell, for: indexPath) as? EditNameDiscribeTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            cell.selectionStyle = .none
            if let nameTask = issues?.taskName, !nameTask.isNullOrWhiteSpace {
                cell.fillTable(nil, nameTask)
            } else {
                cell.fillTable("Название задачи".localized, nil)
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.delegete = self
            delegete = cell
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditNameDiscribeTaskTblViewCell.indificatorCell, for: indexPath) as? EditNameDiscribeTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            if let discribeTask = issues?.taskDiscribe, !discribeTask.isNullOrWhiteSpace {
                cell.fillTable(nil, discribeTask)
            } else {
                cell.fillTable("Описание задачи".localized, nil)
            }
            cell.selectionStyle = .none
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.delegete = self
            delegete = cell
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditDateTaskTblViewCell.indificatorCell, for: indexPath) as? EditDateTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            if let dateTask = laborCoast?.date, let ischange = isChande, ischange{
                cell.fillTable(placeholder: nil, date: dateTask, iconName: UIImage(named: "Vector"))
            } else {
                cell.fillTable(placeholder: "Дата окончание".localized, date: nil, iconName: UIImage(named: "Vector"))
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.delegete = self
            delegete = cell
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditHourTaskTblViewCell.indificatorCell, for: indexPath) as? EditHourTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            if let countHour = laborCoast?.hourCount, let ischange = isChande, ischange {
                cell.fillTable(placeholder: nil, hour: countHour, iconName: UIImage(named: "time-left (1) 1"))
            } else {
                cell.fillTable(placeholder: "Колличество часов на задачу".localized, hour: nil, iconName: UIImage(named: "time-left (1) 1"))
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.delegete = self
            delegete = cell
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditEmployeeAndTaskTaskTblViewCell.indificatorCell, for: indexPath) as? EditEmployeeAndTaskTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            if let employee = employees {
                if let isChange = isChande, isChange {
                    cell.fillTable(UIImage(named: "Vector (1)"), nil, employee: employee)
                } else {
                    cell.fillTable(UIImage(named: "Vector (1)"), nil, employee: employee)
                }
            } else if let isChange = isChande, !isChange {
                cell.fillTable(UIImage(named: "Vector (1)"), "Сотрудник".localized, employee: nil)
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditEmployeeAndTaskTaskTblViewCell.indificatorCell, for: indexPath) as? EditEmployeeAndTaskTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            if let project = project {
                if let isChange = isChande, isChange {
                    cell.fillTable(UIImage(named: "Vector (1)"), nil, project: project)
                } else {
                    cell.fillTable(UIImage(named: "Vector (1)"), nil, project: project)
                }
            } else if let isChange = isChande, !isChange {
                cell.fillTable(UIImage(named: "Vector (1)"), "Проект".localized, project: nil)
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditDateTaskTblViewCell.indificatorCell, for: indexPath) as? EditDateTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            delegete = cell
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension NewTaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 4:
            let vc = SelectionListViewController()
            delegete = vc
            let (activityIndicator, blurEffectView) = setupBlurAndActivityIndicator()
            loadEmployees(compleat: {
                DispatchQueue.main.async {
                    vc.modalPresentationStyle = .custom
                    vc.transitioningDelegate = self
                    vc.delegete = self
                    let navigationController = UINavigationController(rootViewController: vc)
                    self.handleSucsess(activityIndicator, blurEffectView)
                    self.present(navigationController, animated: true, completion: nil)
                }
            })
        case 5:
            let vc = SelectionListViewController()
            delegete = vc
            let (activityIndicator, blurEffectView) = setupBlurAndActivityIndicator()
            loadProject(compleat: {
                DispatchQueue.main.async {
                    vc.modalPresentationStyle = .custom
                    vc.transitioningDelegate = self
                    vc.delegete = self
                    let navigationController = UINavigationController(rootViewController: vc)
                    self.handleSucsess(activityIndicator, blurEffectView)
                    self.present(navigationController, animated: true, completion: nil)
                }
                
            })
            
        default:
            return
        }
    }
}

// MARK: - EditNameDiscribeTaskTblViewCellDelegate
extension NewTaskViewController: EditNameDiscribeTaskTblViewCellDelegate {
    func editNameDiscribeTaskTblViewCell(_ cell: EditNameDiscribeTaskTblViewCell, didChanged value: String) {
        let indexPatch = tblNewTask.indexPath(for: cell)
        switch indexPatch?.row {
        case 0:
            issues?.taskName = value
        case 1:
            issues?.taskDiscribe = value
        default:
            return
        }
    }
}

// MARK: - EditDateTblViewCellDelegate
extension NewTaskViewController: EditDateTblViewCellDelegate {
    func editDateTblViewCell(_ cell: EditDateTaskTblViewCell, didChanged value: Date) {
        laborCoast?.date = value
    }
}

// MARK: - EditHourTaskTblViewCellDelegate
extension NewTaskViewController: EditHourTaskTblViewCellDelegate {
    func editHourTaskTblViewCellTblViewCell(_ cell: EditHourTaskTblViewCell, didChanged value: Int) {
        laborCoast?.hourCount = value
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension NewTaskViewController: UIViewControllerTransitioningDelegate {
    
}

// MARK: - SelectionListViewControllerDelegete
extension NewTaskViewController: SelectionListViewControllerDelegete {
    
    func selectionListViewController(_ cell: SelectionListViewController, didSelected value: Project) {
        self.project = value
        tblNewTask.reloadData()
    }
    
    func selectionListViewController(_ cell: SelectionListViewController, didSelected value: [Employee]) {
        self.employees = value
        tblNewTask.reloadData()
    }
}

// MARK: - CalendarTaskViewControllerDelegate
extension NewTaskViewController: CalendarTaskViewControllerDelegate {
    func calendarTaskViewController(_ viewController: CalendarTaskViewController, didLoadEmployees: [Employee], isues: Issues, laborCoast: LaborCost, project: Project) {
        self.isChande = true
        self.employees = didLoadEmployees
        self.issues = isues
        self.laborCoast = laborCoast
        self.project = project
    }
    
    func calendarTaskViewController(_ viewController: CalendarTaskViewController, didDeleateData witchId: Int) {
        return
    }
    
    func calendarTaskViewController(_ viewController: CalendarTaskViewController) {
        return
    }
}
