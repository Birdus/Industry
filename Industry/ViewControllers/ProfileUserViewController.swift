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
    
    private lazy var tblCountCompliteTask: UITableView = {
        let tbl = UITableView()
        tbl.register(UserCountTaskTblViewCell.self, forCellReuseIdentifier: UserCountTaskTblViewCell.indificatorCell)
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.dataSource = self
        tbl.delegate = self
        tbl.separatorStyle = .none
        tbl.separatorColor = .white
        tbl.isScrollEnabled = false
        return tbl
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(collViewDescribeUser)
        view.addSubview(tblCountCompliteTask)
        self.navigationController?.isNavigationBarHidden = true
        
        NSLayoutConstraint.activate([
            collViewDescribeUser.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            collViewDescribeUser.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collViewDescribeUser.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collViewDescribeUser.heightAnchor.constraint(equalToConstant: ((UIScreen.main.bounds.size.height/2 + collViewDescribeUser.contentOffset.y))/1.5),
            
            tblCountCompliteTask.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tblCountCompliteTask.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tblCountCompliteTask.topAnchor.constraint(equalTo: collViewDescribeUser.bottomAnchor, constant: 5),
            tblCountCompliteTask.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25),
        ])
        
        tblCountCompliteTask.rowHeight = ((UIScreen.main.bounds.size.height/2 + tblCountCompliteTask.contentOffset.y) / 2 ) / 2
    }
}

extension ProfileUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .gray
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .gray
        return view
    }
}

extension ProfileUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCountTaskTblViewCell.indificatorCell, for: indexPath) as? UserCountTaskTblViewCell else {
                fatalError("Unable to dequeue cell.")
            }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.fiillTable(10, 20)
        return cell
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
