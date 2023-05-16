//
//  SettingUserViewController.swift
//  Industry
//
//  Created by  Даниил on 24.04.2023.
//

import UIKit

class SettingUserViewController: UIViewController {
    
    private let indificatorDefaultCell = "indificatorDefaultCell"
    
    private lazy var tblMenuView: UITableView = {
        let tableView = UITableView()
        tableView.register(SetingUserTblViewCell.self, forCellReuseIdentifier: SetingUserTblViewCell.indificatorCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: indificatorDefaultCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var btnBack: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Назад".localized, style: .plain, target: self, action: #selector(btnBack_Click))
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @objc
    private func btnBack_Click(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func configureUI() {
        self.navigationItem.leftBarButtonItem = btnBack
        self.navigationController?.isNavigationBarHidden = false
        self.view.backgroundColor = .white
        self.view.addSubview(tblMenuView)
        NSLayoutConstraint.activate([
            tblMenuView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tblMenuView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tblMenuView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tblMenuView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.navigationController?.isNavigationBarHidden = false
    }
}


extension SettingUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: indificatorDefaultCell, for: indexPath)
            cell.textLabel?.text = "Уведомления".localized
            cell.textLabel?.textAlignment = .left
            cell.selectionStyle = .none
            cell.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10)/1.5,weight: .bold)
            cell.contentView.isUserInteractionEnabled = false
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SetingUserTblViewCell.indificatorCell, for: indexPath) as? SetingUserTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            cell.fiillTable("Выключить все уведомления".localized, false)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.contentView.isUserInteractionEnabled = false
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SetingUserTblViewCell.indificatorCell, for: indexPath) as? SetingUserTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            cell.fiillTable("Собрание".localized, true)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.contentView.isUserInteractionEnabled = false
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SetingUserTblViewCell.indificatorCell, for: indexPath) as? SetingUserTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            cell.fiillTable("Новой задачи".localized, false)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.contentView.isUserInteractionEnabled = false
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SetingUserTblViewCell.indificatorCell, for: indexPath) as? SetingUserTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            cell.fiillTable("Конец задачи".localized, false)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.contentView.isUserInteractionEnabled = false
            return cell
        case 5:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: indificatorDefaultCell, for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = "Безопасность".localized
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10)/1.5,weight: .bold)
            return cell
        case 6:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: indificatorDefaultCell, for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = "Политика кондифициальности".localized
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10)/2)
            cell.accessoryType = .disclosureIndicator
            return cell
        case 7:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: indificatorDefaultCell, for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = "Изменить пароль".localized
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10)/2)
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: indificatorDefaultCell, for: indexPath)
            return cell
        }
    }
}

extension SettingUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.size.height
        let contentOffsetY = tableView.contentOffset.y
        return ((screenHeight / 2 + contentOffsetY) / 2)/2.5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .clear
        return view
    }
}
