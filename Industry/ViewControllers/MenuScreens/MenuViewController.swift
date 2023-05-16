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
    
    private lazy var imgChange: UIImage = {
        let imageView = UIImage(named: "userAvatar") ?? UIImage()
        return imageView
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
        var vc: UIViewController = UIViewController()
        switch indexPath.row {
        case 2:
            vc = NotificationListViewController()
        case 3:
            vc = StatisticUserViewController()
        case 4:
            vc = SettingUserViewController()
        default:
            return
        }
        let vcNav = UINavigationController(rootViewController: vc)
        vcNav.modalPresentationStyle = .fullScreen
        navigationController?.present(vcNav, animated: true, completion: nil)
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
            cell.fiillTable("Гетманцев Даниил Олегович", "Directum", "Junior", imgChange)
            cell.separatorInset = UIEdgeInsets(top: 0, left: view.bounds.width / 4, bottom: 0, right: 0)
            cell.delegete = self
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
            cell.accessoryType = .disclosureIndicator
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

extension MenuViewController: HeadMenuTblViewCellDelegate {
    func headMenuTblViewCell(_ cell: HeadMenuTblViewCell, didFinishPickingImage avatar: UIImageView) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = false
        self.present(picker, animated: true)
    }
}

extension MenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgChange = image
            menuTableView.reloadData()
            dismiss(animated: true)
        } else {
            picker.dismiss(animated: true, completion: nil)
            let alControl:UIAlertController = {
                let alControl = UIAlertController(title: "Ошибка".localized, message: "Фотография не найденна".localized, preferredStyle: .alert)
                
                let btnOk: UIAlertAction = {
                    let btn = UIAlertAction(title: "Ok".localized,
                                            style: .default,
                                            handler: nil)
                    return btn
                }()
                alControl.addAction(btnOk)
                return alControl
            }()
            present(alControl, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
