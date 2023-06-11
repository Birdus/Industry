//
//  RecovoryPasswordViewController.swift
//  Industry
//
//  Created by  Даниил on 22.04.2023.
//

import UIKit

class RecovoryPasswordViewController: UIViewController {
    
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
    
    private lazy var containerImg: UIView = {
        let view = UIView()
        view.accessibilityIdentifier = "containerImg"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 70
        view.backgroundColor =  .white
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 0.3
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.masksToBounds = false
        return view
    }()
    
    /// An image view displaying the company logo.
    private lazy var imgCompany: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "logoCompany.png")
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFill
        icon.clipsToBounds = true
        icon.accessibilityIdentifier = "imgCompany"
        return icon
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
        self.view.accessibilityIdentifier = "RecovoryPasswordViewController"
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
    private func setupBlurAndActivityIndicator() -> (UIActivityIndicatorView, UIVisualEffectView) {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.6
        blurEffectView.contentView.addSubview(activityIndicator)
        view.addSubview(blurEffectView)
        return (activityIndicator, blurEffectView)
    }
    
    private func handleSucsess(_ activityIndicator: UIActivityIndicatorView, _ blurEffectView: UIVisualEffectView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            blurEffectView.removeFromSuperview()
        }
    }
    
    /// Configures the UI elements of the view controller.
    private func configureUI() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barStyle = .default
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = btnBack
        view.backgroundColor = .white
        view.addSubview(collRecovery)
        view.addSubview(containerImg)
        containerImg.addSubview(imgCompany)
        NSLayoutConstraint.activate([
            collRecovery.topAnchor.constraint(equalTo: containerImg.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            collRecovery.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collRecovery.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collRecovery.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            // Company logo
            containerImg.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.45),
            containerImg.heightAnchor.constraint(equalTo: containerImg.widthAnchor),
            containerImg.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            containerImg.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            imgCompany.topAnchor.constraint(equalTo: containerImg.topAnchor, constant: 15),
            imgCompany.leadingAnchor.constraint(equalTo: containerImg.leadingAnchor, constant: 15),
            imgCompany.trailingAnchor.constraint(equalTo: containerImg.trailingAnchor, constant: -15),
            imgCompany.bottomAnchor.constraint(equalTo: containerImg.bottomAnchor, constant: -15),
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
        cell.delegete = self
        cell.fillCell(isAutohorizion: false)
        return cell
    }
}

// MARK: - RecovoryPasswordCollViewCellDelegate
extension RecovoryPasswordViewController: RecovoryPasswordCollViewCellDelegate {
    func recovoryPasswordCollViewCell(_ viewController: RecovoryPasswordCollViewCell, didChange values: RecovoryPasswordInfo, complition: @escaping () -> Void) {
        let (activityIndicator, blurEffectView) = setupBlurAndActivityIndicator()
        switch values {
        case .acssesCode(let code):
            apiManagerIndustry?.post(request: ForecastType.CheakValidConfirmationCode, data: ConfirmResetPassword(confirmationCode: code, newPassword: nil), completionHandler: { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.handleSucsess(activityIndicator, blurEffectView)
                        complition()
                    }
                case .successArray(_):
                    DispatchQueue.main.async {
                        self.handleSucsess(activityIndicator, blurEffectView)
                        self.showAlController(messege: "Неверные данные!".localized)
                    }
                case .failure(let error): DispatchQueue.main.async {
                    self.handleSucsess(activityIndicator, blurEffectView)
                    let errorsUser = INDNetworkingError.init(error)
                    self.showAlController(messege: errorsUser.errorMessage)
                }
                }
            })
        case .error(let messege):
            self.handleSucsess(activityIndicator, blurEffectView)
            showAlController(messege: messege)
        case .mail(let mail):
            let resetPasswordEmail = ResetPasswordEmail(email: mail)
            apiManagerIndustry?.post(request: ForecastType.ResetPassword, data: resetPasswordEmail, completionHandler: { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.handleSucsess(activityIndicator, blurEffectView)
                        complition()
                    }
                case .successArray(_):
                    DispatchQueue.main.async {
                        self.handleSucsess(activityIndicator, blurEffectView)
                        self.showAlController(messege: "Неверные данные!".localized)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.handleSucsess(activityIndicator, blurEffectView)
                        let errorsUser = INDNetworkingError.init(error)
                        self.showAlController(messege: errorsUser.errorMessage)
                    }
                }
            })
        }
    }
    
    func recovoryPasswordCollViewCell(_ viewController: RecovoryPasswordCollViewCell, didChange password: String, code: Int) {
        let (activityIndicator, blurEffectView) = setupBlurAndActivityIndicator()
        apiManagerIndustry?.post(request: ForecastType.ConfirmResetPassword, data: ConfirmResetPassword(confirmationCode: code, newPassword: password), completionHandler: { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.handleSucsess(activityIndicator, blurEffectView)
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
                    self.handleSucsess(activityIndicator, blurEffectView)
                    self.showAlController(messege: "Неверные данные!".localized)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.handleSucsess(activityIndicator, blurEffectView)
                    let errorsUser = INDNetworkingError.init(error)
                    self.showAlController(messege: errorsUser.errorMessage)
                }
            }
        })
    }
}
