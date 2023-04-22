//
//  TaskListViewController.swift
//  Industry
//
//  Created by Даниил on 09.03.2023.
//

import UIKit



class NotificationListViewController: UIViewController {
    
    
    lazy private var collViewTask: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: (self.view.bounds.width - 20), height: (self.view.bounds.width) / 3)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(NotificationUserViewCell.self, forCellWithReuseIdentifier: NotificationUserViewCell.indificatorCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private var tabBarScreenDefinition : TabBarScreenDefinition = TabBarScreenDefinition()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(collViewTask)
        self.navigationController?.isNavigationBarHidden = true
        collViewTask.layer.borderWidth = 0
        collViewTask.layer.borderColor = UIColor.clear.cgColor
        collViewTask.layer.borderWidth = 0
        if let tabBarController = self.tabBarController as? MenuTabBarController {
            tabBarController.delegete = self
                }
        NSLayoutConstraint.activate([
            collViewTask.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collViewTask.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collViewTask.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collViewTask.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}

extension NotificationListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collViewTask.dequeueReusableCell(withReuseIdentifier: NotificationUserViewCell.indificatorCell, for: indexPath) as! NotificationUserViewCell
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        switch indexPath.row {
        case 0:
            cell.fillTable(UIImage(named: NotificationCollRow.deadLineTask.iconNotification),"Конец задачи", "Внимание у вас заканчиваеться срок выполнения задачи", "10.09.2023")
        case 1:
            cell.fillTable(UIImage(named: NotificationCollRow.event.iconNotification),"Собрание", "Внимание у вас собрание в 357 кабинете", "10.09.2023")
        case 2:
            cell.fillTable(UIImage(named: NotificationCollRow.newTask.iconNotification),"Новая задача", "Внимание у вас новая задача", "10.09.2023")
        default:
            cell.fillTable(UIImage(named: NotificationCollRow.event.iconNotification),"", "","")
        }
        cell.backgroundColor = .lightGray
        return cell
    }
}

extension NotificationListViewController: UICollectionViewDelegateFlowLayout  {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // MARK: - Other methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 20)
    }
}

extension NotificationListViewController: UICollectionViewDelegate {
    
}

extension NotificationListViewController: MenuTabBarControllerDelegate {
    func menuTabBarControllerDelegate(_ tabController: MenuTabBarController, didSelectTab index: Int) {
        tabBarScreenDefinition = TabBarScreenDefinition(rawValue: index)!
        return
    }
}
