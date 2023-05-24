//
//  NewTaskViewController.swift
//  Industry
//
//  Created by  Даниил on 22.05.2023.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    private var originYView: CGRect = CGRect()

    // MARK: - Private UI
    private lazy var tblNewTask: UITableView = {
        let tableView = UITableView()
        tableView.register(EditNameDiscribeTaskTblViewCell.self, forCellReuseIdentifier: EditNameDiscribeTaskTblViewCell.indificatorCell)
        tableView.register(EditHourTaskTblViewCell.self, forCellReuseIdentifier: EditHourTaskTblViewCell.indificatorCell)
        tableView.register(EditEmployeeTaskTblViewCell.self, forCellReuseIdentifier: EditEmployeeTaskTblViewCell.indificatorCell)
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
    
    private lazy var btnSave: UIButton = {
        let btn = UIButton()
        btn.accessibilityIdentifier = "btnSave"
        btn.backgroundColor = .white
        btn.setTitle("Coхранить".localized, for: .normal)
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
        btn.addTarget(self, action: #selector(btnSave_Click), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotification()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        originYView = view.frame
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - Acrion
    
    @objc
    private func btnSave_Click(_ notification: UIButton) {
        
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
    
    // MARK: - Private func
    private func configureUI() {
        self.view.backgroundColor = UIColor(red: 0.157, green: 0.535, blue: 0.821, alpha: 1)
        self.view.addSubview(tblNewTask)
        self.view.addSubview(btnSave)
        NSLayoutConstraint.activate([
            tblNewTask.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tblNewTask.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tblNewTask.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            
            btnSave.topAnchor.constraint(equalTo: tblNewTask.bottomAnchor, constant: 5), // Изменено значение отступа

            btnSave.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            btnSave.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10), // Изменено значение отступа
            btnSave.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3)
        ])
    }

}

// MARK: - UITableViewDataSource
extension NewTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return self.view.bounds.height/4
        default:
            return self.view.bounds.height/6.5
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditNameDiscribeTaskTblViewCell.indificatorCell, for: indexPath) as? EditNameDiscribeTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            cell.selectionStyle = .none
            cell.fillTable("Название задачи".localized)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.delegete = self
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditNameDiscribeTaskTblViewCell.indificatorCell, for: indexPath) as? EditNameDiscribeTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            cell.fillTable("Описание задачи".localized)
            cell.selectionStyle = .none
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.delegete = self
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditDateTaskTblViewCell.indificatorCell, for: indexPath) as? EditDateTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            cell.fiillTable("Дата окончание задачи", UIImage(named: "Vector"))
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.delegete = self
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditHourTaskTblViewCell.indificatorCell, for: indexPath) as? EditHourTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            cell.fiillTable("Колличество часов на задачу", UIImage(named: "time-left (1) 1"))
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.delegete = self
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditEmployeeTaskTblViewCell.indificatorCell, for: indexPath) as? EditEmployeeTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            cell.fiillTable("Сотрудник", UIImage(named: "Vector (1)"))
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditDateTaskTblViewCell.indificatorCell, for: indexPath) as? EditDateTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension NewTaskViewController: UITableViewDelegate {
    
}

// MARK: - EditNameDiscribeTaskTblViewCellDelegate
extension NewTaskViewController: EditNameDiscribeTaskTblViewCellDelegate {
    func editNameDiscribeTaskTblViewCell(_ cell: EditNameDiscribeTaskTblViewCell, didChanged value: String) {
        
    }
}

// MARK: - EditDateTblViewCellDelegate
extension NewTaskViewController: EditDateTblViewCellDelegate {
    func editDateTblViewCell(_ cell: EditDateTaskTblViewCell, didChanged value: Date) {
        
    }
}

// MARK: - EditHourTaskTblViewCellDelegate
extension NewTaskViewController: EditHourTaskTblViewCellDelegate {
    func editHourTaskTblViewCellTblViewCell(_ cell: EditHourTaskTblViewCell, didChanged value: Int) {
        
    }
}


