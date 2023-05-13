//
//  RecovoryPasswordViewController.swift
//  Industry
//
//  Created by  Даниил on 22.04.2023.
//

import UIKit

class RecovoryPasswordViewController: UIViewController {
    // MARK: - Properties
    
    // Collection view for displaying recovery options
    private lazy var collRecovery: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: (self.view.bounds.width - 20), height: (self.view.bounds.width)/1.6)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecovoryPasswordCollViewCell.self, forCellWithReuseIdentifier: RecovoryPasswordCollViewCell.indificatorCell)
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    /// An image view displaying the company logo.
    private lazy var imgCompany: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "logoCompany.png")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    // Back button
    private lazy var btnBack: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Назад".localized, style: .plain, target: self, action: #selector(btnBack_Click))
        return btn
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    /// Handles the click event for the back button.
    ///
    /// - Parameter sender: The button that was clicked.
    @objc
    private func btnBack_Click(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /// Keyboard will show notification handler
    @objc
    private func kbWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if view.frame.origin.y == 0 {
                let keyboardHeight = keyboardFrame.height
                let bottomSpace = view.frame.height - (collRecovery.frame.origin.y + collRecovery.frame.height)
                view.frame.origin.y -= max(0, keyboardHeight - bottomSpace - 30)
            }
        }
    }
    
    /// Keyboard will hide notification handler
    @objc
    private func kbWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    // MARK: - Keyboard Notifications
    /// Register for keyboard notifications
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Private Methods
    
    /// Configures the UI elements of the view controller.
    private func configureUI() {
        self.view.addSubview(collRecovery)
        view.addSubview(imgCompany)
        self.navigationItem.leftBarButtonItem = btnBack
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
        collRecovery.layer.borderWidth = 0
        collRecovery.layer.borderColor = UIColor.clear.cgColor
        registerForKeyboardNotification()
        
        NSLayoutConstraint.activate([
            collRecovery.topAnchor.constraint(equalTo: imgCompany.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            collRecovery.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collRecovery.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collRecovery.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            // Company logo
            imgCompany.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -150),
            imgCompany.heightAnchor.constraint(equalTo: imgCompany.widthAnchor),
            imgCompany.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imgCompany.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegate
extension RecovoryPasswordViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension RecovoryPasswordViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecovoryPasswordCollViewCell.indificatorCell, for: indexPath) as! RecovoryPasswordCollViewCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.backgroundColor =  UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 0.5)
        return cell
    }
}
