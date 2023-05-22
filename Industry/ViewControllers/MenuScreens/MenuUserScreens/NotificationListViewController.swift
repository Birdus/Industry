//
//  NotificationListViewController.swift
//  Industry
//
//  Created by Даниил on 09.03.2023.
//
/**
 A custom NotificationListViewController used for the Industry app's .
 
 - Author: Daniil
 - Version: 1.0
 */
import UIKit

/// A view controller that displays a list of notifications.
class NotificationListViewController: UIViewController {
    
    // MARK: - Private UI
    /// The collection view that displays the notifications.
    private lazy var collNotification: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: (view.bounds.width - 20), height: (view.bounds.width) / 3)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(NotificationUserViewCell.self, forCellWithReuseIdentifier: NotificationUserViewCell.indificatorCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var btnAddNotification: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "+".localized, style: .done, target: self, action: #selector(btnAddNotification_Click))
        return btn
    }()
    
    private lazy var btnBack: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Назад".localized, style: .plain, target: self, action: #selector(btnBack_Click))
        return btn
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    /// Func click button back
    @objc
    private func btnBack_Click(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc
    private func btnAddNotification_Click(_ sender: UIButton) {
        
    }
    
    // MARK: - Private Methods
    /// Configures the UI elements of the view controller.
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(collNotification)
        self.navigationItem.leftBarButtonItem = btnBack
        self.navigationItem.rightBarButtonItem = btnAddNotification
        self.navigationController?.isNavigationBarHidden = false
        collNotification.layer.borderWidth = 0
        collNotification.layer.borderColor = UIColor.clear.cgColor
        NSLayoutConstraint.activate([
            collNotification.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collNotification.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collNotification.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collNotification.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension NotificationListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationUserViewCell.indificatorCell, for: indexPath) as! NotificationUserViewCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        switch indexPath.row {
        case 0:
            cell.fillTable(iconImage: UIImage(named: NotificationCollRow.deadLineTask.iconNotification),
                           title: "Конец задачи",
                           deadline: "Внимание у вас заканчиваеться срок выполнения задачи",
                           description: "10.09.2023")
        case 1:
            cell.fillTable(iconImage: UIImage(named: NotificationCollRow.event.iconNotification),
                           title: "Собрание",
                           deadline: "Внимание у вас собрание в 357 кабинете",
                           description: "10.09.2023")
        case 2:
            cell.fillTable(iconImage: UIImage(named: NotificationCollRow.newTask.iconNotification),
                           title: "Новая задача",
                           deadline: "Внимание у вас новая задача",
                           description: "10.09.2023")
        default:
            cell.fillTable(iconImage: UIImage(named: NotificationCollRow.event.iconNotification),
                           title: "",
                           deadline: "",
                           description: "")
        }
        cell.backgroundColor = .lightGray
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NotificationListViewController: UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 20)
    }
}

// MARK: - UICollectionViewDelegate
extension NotificationListViewController: UICollectionViewDelegate {
    
}

