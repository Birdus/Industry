//
//  TaskListViewController.swift
//  Industry
//
//  Created by Даниил on 09.03.2023.
//

import UIKit

class TaskListViewController: UIViewController {
    
    lazy private var tabBar: UITabBar = {
        let tabBar = UITabBar()
        tabBar.delegate = self
        tabBar.translatesAutoresizingMaskIntoConstraints = false

        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: (self.view.bounds.width/24))]
        let items = [
            UITabBarItem(title: "Задачи", image: UIImage(named: "iconTask"), selectedImage: UIImage(named: "iconTask")),
            UITabBarItem(title: "Мои задачи", image: UIImage(named: "iconUserTask"), selectedImage: UIImage(named: "iconUserTask")),
            UITabBarItem(title: "Профиль", image: UIImage(named: "iconAccount"), selectedImage: UIImage(named: "iconAccount"))
        ]
        items.forEach { item in
            item.setTitleTextAttributes(attributes, for: .normal)
        }
        tabBar.items = items

        return tabBar
    }()

    lazy private var tblTask: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            layout.itemSize = CGSize(width: (self.view.bounds.width - 20), height: (self.view.bounds.width) / 3)

            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .white
            collectionView.register(TaskCollViewCell.self, forCellWithReuseIdentifier: TaskCollViewCell.indificatorCell)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.translatesAutoresizingMaskIntoConstraints = false

            return collectionView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(tblTask)
        view.addSubview(tabBar)
        NSLayoutConstraint.activate([
            tblTask.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tblTask.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tblTask.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tblTask.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: (view.frame.height / 14))
        ])
    }
    
}

extension TaskListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tblTask.dequeueReusableCell(withReuseIdentifier: TaskCollViewCell.indificatorCell, for: indexPath) as! TaskCollViewCell
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.fillTable("TaskName", "Dead Line", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        return cell
    }
}

extension TaskListViewController: UICollectionViewDelegateFlowLayout  {
    
    
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

extension TaskListViewController: UICollectionViewDelegate {
    
}

extension TaskListViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Выбрана кнопка \(item.title ?? "")")
    }
}
