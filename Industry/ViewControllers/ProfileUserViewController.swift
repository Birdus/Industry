//
//  ProfileUserViewController.swift
//  Industry
//
//  Created by Даниил on 14.03.2023.
//

import UIKit

class ProfileUserViewController: UIViewController {
    
    lazy private var collViewDescribeUser: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: (self.view.bounds.width - 20), height: (self.view.bounds.width)/2)
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UserDescriptionCollViewCell.self, forCellWithReuseIdentifier: UserDescriptionCollViewCell.indificatorCell)
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
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
        view.addSubview(collViewDescribeUser)
        self.navigationController?.isNavigationBarHidden = true
        
        NSLayoutConstraint.activate([
            collViewDescribeUser.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            collViewDescribeUser.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collViewDescribeUser.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collViewDescribeUser.heightAnchor.constraint(equalToConstant: ((UIScreen.main.bounds.size.height/2 + collViewDescribeUser.contentOffset.y)))
        ])
    }
}

extension ProfileUserViewController: UICollectionViewDelegate {
    
}

extension ProfileUserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collViewDescribeUser.dequeueReusableCell(withReuseIdentifier: UserDescriptionCollViewCell.indificatorCell, for: indexPath) as! UserDescriptionCollViewCell
        
        cell.backgroundColor = UIColor(ciColor: CIColor.init(red: 0/255, green: 130/255, blue: 255/255))
        cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        cell.layer.cornerRadius = 10
        cell.fillTable("Даниил", "Гетманцев", "Олегович", "Админ", "IT", 45523)

        return cell
    }
    
}
