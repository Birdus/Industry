//
//  RecovoryPasswordViewController.swift
//  Industry
//
//  Created by  Даниил on 22.04.2023.
//

import UIKit

class RecovoryPasswordViewController: UIViewController {
    
    private lazy var collRecovery: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: self.view.bounds.height/6.5, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: (self.view.bounds.width - 20), height: (self.view.bounds.width)/1.3)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecovoryPasswordCollViewCell.self, forCellWithReuseIdentifier: RecovoryPasswordCollViewCell.indificatorCell)
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var btnBack: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Назад".localized, style: .plain, target: self, action: #selector(btnBack_Click))
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    /// Func click button recovery password
    @objc
    private func btnBack_Click(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Privates func
    /// Configures the UI elements of the view controller.
    private func configureUI() {
        self.view.addSubview(collRecovery)
        self.navigationItem.leftBarButtonItem = btnBack
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
        collRecovery.layer.borderWidth = 0
        collRecovery.layer.borderColor = UIColor.clear.cgColor
        
        NSLayoutConstraint.activate([
            collRecovery.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collRecovery.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collRecovery.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collRecovery.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension RecovoryPasswordViewController: UICollectionViewDelegate {
    
}

extension RecovoryPasswordViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecovoryPasswordCollViewCell.indificatorCell, for: indexPath) as! RecovoryPasswordCollViewCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.backgroundColor =  UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
        return cell
    }
    
    
}
