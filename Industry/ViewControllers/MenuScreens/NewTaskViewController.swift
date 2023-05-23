//
//  NewTaskViewController.swift
//  Industry
//
//  Created by  Даниил on 22.05.2023.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    private var originYView: CGFloat = CGFloat()

    // MARK: - Private UI
    private lazy var tblNewTask: UITableView = {
        let tableView = UITableView()
        tableView.register(AddInfoTaskTblViewCell.self, forCellReuseIdentifier: AddInfoTaskTblViewCell.indificatorCell)
        tableView.register(NameTaskTblViewCell.self, forCellReuseIdentifier: NameTaskTblViewCell.indificatorCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorColor = .white
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotification()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        originYView = view.frame.origin.y
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - Acrion
    /// Keyboard will show notification handler
    @objc
    private func kbWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if view.frame.origin.y == originYView{
                    let keyboardHeight = keyboardFrame.height
                    let bottomSpace = view.frame.height - (tblNewTask.frame.origin.y + tblNewTask.frame.height)
                    view.frame.origin.y -= max(0, keyboardHeight - bottomSpace - 25)
            }
        }
    }
    
    /// Keyboard will hide notification handler
    @objc
    private func kbWillHide(_ notification: Notification) {
        self.view.frame.origin.y = originYView
    }
    
    // MARK: - Privates func
    /// Register for keyboard notifications
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Private func
    private func configureUI() {
        self.view.backgroundColor = UIColor(red: 0.157, green: 0.535, blue: 0.821, alpha: 1)
        tblNewTask.backgroundColor = UIColor(red: 0.157, green: 0.535, blue: 0.821, alpha: 1)
        self.view.addSubview(tblNewTask)
        NSLayoutConstraint.activate([
            tblNewTask.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tblNewTask.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tblNewTask.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tblNewTask.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 5)
        ])
    }
}

// MARK: - UITableViewDataSource
extension NewTaskViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return self.view.bounds.height/3
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NameTaskTblViewCell.indificatorCell, for: indexPath) as? NameTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            cell.selectionStyle = .none
            cell.fillTable("Название задачи".localized)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NameTaskTblViewCell.indificatorCell, for: indexPath) as? NameTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            cell.fillTable("Описание задачи".localized)
            cell.selectionStyle = .none
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddInfoTaskTblViewCell.indificatorCell, for: indexPath) as? AddInfoTaskTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            switch indexPath.row {
            case 2:
                cell.fiillTable("Дата окончание задачи", UIImage(named: "Vector"))
            case 3:
                cell.fiillTable("Колличество часов на задачу", UIImage(named: "time-left (1) 1"))
            case 4:
                cell.fiillTable("Сотрудник", UIImage(named: "Vector (1)"))
            default:
                cell.fiillTable("Lorem", UIImage())
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            return cell
        }
        
    }
}

// MARK: - UITableViewDelegate
extension NewTaskViewController: UITableViewDelegate {
    
}
