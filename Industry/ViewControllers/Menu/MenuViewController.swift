// ProfileUserViewController.swift
// Industry
//
// Created by Danil Getmantsev on 14.03.2023.
//

import UIKit

/// MenuViewController displays a menu of options that the user can select from.
class MenuViewController: UIViewController {
    
    // MARK: - Properties
    /// A table view that displays menu items.
    private lazy var menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HeadMenuTblViewCell.self, forCellReuseIdentifier: HeadMenuTblViewCell.indificatorCell)
        tableView.register(UserCountTaskTblViewCell.self, forCellReuseIdentifier: UserCountTaskTblViewCell.indificatorCell)
        tableView.register(MenuItemTblViewCell.self, forCellReuseIdentifier: MenuItemTblViewCell.indificatorCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private Methods
    /// Configures the view controller's UI.
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(menuTableView)
        navigationController?.isNavigationBarHidden = true
        NSLayoutConstraint.activate([
            menuTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            menuTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - UITableViewDelegate

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.size.height
        let contentOffsetY = tableView.contentOffset.y
        switch indexPath.row {
        case 0:
            return ((screenHeight / 2 + contentOffsetY) / 2)/1.5
        case 1:
            return ((screenHeight / 2 + contentOffsetY) / 2)/2
        default:
            return ((screenHeight / 2 + contentOffsetY) / 2)/2.5
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0, 1:
            let userProfileViewController = UserProfileViewController()
            navigationController?.pushViewController(userProfileViewController, animated: true)
        case 2:
            let notificationListViewController = NotificationListViewController()
            navigationController?.pushViewController(notificationListViewController, animated: true)
            return
        case 3:
            let statisticUserViewController = StatisticUserViewController()
            navigationController?.pushViewController(statisticUserViewController, animated: true)
        case 4:
            let settingUserViewController = SettingUserViewController()
            navigationController?.pushViewController(settingUserViewController, animated: true)
        default:
            return
        }
    }
}

// MARK: - UITableViewDataSource

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeadMenuTblViewCell.indificatorCell, for: indexPath) as? HeadMenuTblViewCell else {
                fatalError("Unable to dequeue HeadMenuTableViewCell.")
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.fiillTable("Гетманцев Даниил Олегович", "Directum", "Junior", "userAvatar")
            cell.separatorInset = UIEdgeInsets(top: 0, left: view.bounds.width / 4, bottom: 0, right: 0)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCountTaskTblViewCell.indificatorCell, for: indexPath) as? UserCountTaskTblViewCell else {
                fatalError("Unable to dequeue UserCountTaskTableViewCell.")
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.fiillTable(10, 20)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemTblViewCell.indificatorCell, for: indexPath) as? MenuItemTblViewCell else {
                fatalError("Unable to dequeue MenuItemTableViewCell.")
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            switch indexPath.row {
            case 2:
                cell.fiillTable("Уведомления".localized, UIImage(named:"iconNotification"))
            case 3:
                cell.fiillTable("Статистика".localized, UIImage(named:"iconStatistic"))
            case 4:
                cell.fiillTable("Настройки".localized, UIImage(named:"iconSetting"))
            case 5:
                cell.fiillTable("Выйти".localized, UIImage(named:"iconExit"))
            default:
                cell.fiillTable("", UIImage())
            }
            return cell
        }
    }
}
