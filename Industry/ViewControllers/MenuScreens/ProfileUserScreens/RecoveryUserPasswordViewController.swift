//
//  RecoveryUserPasswordViewController.swift
//  Industry
//
//  Created by  Даниил on 08.06.2023.
//

import UIKit

class RecoveryUserPasswordViewController: UIViewController {
    
    private var apiManagerIndustry: APIManagerIndustry? = APIManagerIndustry()
    
    // MARK: - Private UI
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
        collectionView.accessibilityIdentifier = "collRecovery"
        collectionView.layer.borderWidth = 0
        collectionView.layer.borderColor = UIColor.clear.cgColor
        return collectionView
    }()
    
    // Back button
    private lazy var btnBack: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "✖️", style: .plain, target: self, action: #selector(btnBack_Click))
        btn.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.monospacedDigitSystemFont(ofSize: CGFloat(UIScreen.main.bounds.width/8)/2, weight: .bold),
        ], for: .normal)
        btn.accessibilityIdentifier = "btnBack"
        return btn
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerForKeyboardNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        apiManagerIndustry = nil
        print("sucsses closed RecovoryPasswordViewController")
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
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barStyle = .default
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = btnBack
        view.backgroundColor = .white
        view.addSubview(collRecovery)
        NSLayoutConstraint.activate([
            collRecovery.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            collRecovery.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collRecovery.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collRecovery.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    private func showAlController(messege: String) {
        let alControl:UIAlertController = {
            let alControl = UIAlertController(title: "Ошибка".localized, message: messege, preferredStyle: .alert)
            let btnOk: UIAlertAction = {
                let btn = UIAlertAction(title: "Ok".localized,
                                        style: .default,
                                        handler: nil )
                return btn
            }()
            alControl.addAction(btnOk)
            return alControl
        }()
        self.present(alControl, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate
extension RecoveryUserPasswordViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension RecoveryUserPasswordViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecovoryPasswordCollViewCell.indificatorCell, for: indexPath) as! RecovoryPasswordCollViewCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.delegete = self
        cell.fillCell(isAutohorizion: true)
        return cell
    }
}

extension RecoveryUserPasswordViewController: RecovoryPasswordCollViewCellDelegate {
    func recovoryPasswordCollViewCell(_ viewController: RecovoryPasswordCollViewCell, didChange values: RecovoryPasswordInfo, complition: @escaping () -> Void) {
        switch values {
        case .acssesCode(let code):
            apiManagerIndustry?.post(request: ForecastType.CheakValidConfirmationCode, data: ConfirmResetPassword(confirmationCode: code, newPassword: nil), completionHandler: { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        complition()
                    }
                case .successArray(_):
                    DispatchQueue.main.async {
                        self.showAlController(messege: "Неверные данные!".localized)
                    }
                case .failure(let error): DispatchQueue.main.async {
                    self.showAlController(messege: error.localizedDescription.localized)
                }
                }
            })
        case .error(let messege):
            showAlController(messege: messege)
        case .mail(_):
            break
        }
    }
    
    func recovoryPasswordCollViewCell(_ viewController: RecovoryPasswordCollViewCell, didChange password: String, code: Int) {
        apiManagerIndustry?.post(request: ForecastType.ConfirmResetPassword, data: ConfirmResetPassword(confirmationCode: code, newPassword: password), completionHandler: { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    let alControl:UIAlertController = {
                        let alControl = UIAlertController(title: "Успех".localized, message: "Пароль успешно изменён!".localized, preferredStyle: .alert)
                        let btnOk: UIAlertAction = {
                            let btn = UIAlertAction(title: "Ok".localized,
                                                    style: .default,
                                                    handler: {_ in
                                                        self.dismiss(animated: true, completion: nil)
                                                    } )
                            return btn
                        }()
                        alControl.addAction(btnOk)
                        return alControl
                    }()
                    self.present(alControl, animated: true, completion: nil)
                }
            case .successArray(_):
                DispatchQueue.main.async {
                self.showAlController(messege: "Неверные данные!".localized)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                self.showAlController(messege: error.localizedDescription.localized)
                }
            }
        })
    }
}