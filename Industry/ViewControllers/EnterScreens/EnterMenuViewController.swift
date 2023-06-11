//
//  EnterMenuViewController.swift
//  Industry
//
//  Created by birdus on 24.02.2023.
//

import UIKit

/**
 The EnterMenuViewController displays a menu for user authentication.
 
 The menu consists of a table view with two text fields for user input and two buttons: "Enter" and "Recover Password". The user can input their login and password, and if they click the "Enter" button, the app switches to the main menu. If they click the "Recover Password" button, nothing happens.
 
 The view controller has the following properties:
 
 - tblAuthentication: a table view for user input.
 - btnEnter: a button for entering the app.
 - imgCompany: an image view displaying the company logo.
 - btnRecoveryPass: a button for password recovery.
 - The view controller has the following methods:
 
 configureUI(): a private method responsible for setting the UI.
 
 - registerForKeyboardNotifacation(): a private method for registering keyboard notifications.
 - BtnRecoveryPass_Click(_:): a private method that is called when the "Recover Password" button is tapped.
 - BtnEnter_Click(_:): a private method that is called when the "Enter" button is tapped.
 - kbWillShow(_:): a private method that is called when the keyboard will show.
 - kbWillHide(_:): a private method that is called when the keyboard will hide.
 - The view controller conforms to the following protocols:
 
 UITableViewDataSource: to provide data to the table view.
 UITableViewDelegate: to handle interactions with the table view.
 Example usage:
 
 swift
 Copy code
 let enterMenuVC = EnterMenuViewController()
 navigationController.pushViewController(enterMenuVC, animated: true)
 */
protocol EnterMenuViewControllerDelegate: AnyObject {
    func enterMenuViewController(_ enterMenuViewController: EnterMenuViewController, didLoadEmployeeWitch id: Int, completion: @escaping () -> Void, failer: @escaping (_ error : Error) -> Void)
}

class EnterMenuViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegete: EnterMenuViewControllerDelegate!
    private var usserLogin: String?
    private var usserPassword: String?
    private var apiManagerIndustry: APIManagerIndustry?
    
    // MARK: - Private UI
    /// A button for entering the app.
    private lazy var btnEnter: UIButton = {
        let btn = UIButton()
        btn.accessibilityIdentifier = "btnEnter"
        btn.backgroundColor = .white
        btn.setTitle("Войти".localized, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        btn.clipsToBounds = false
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btn.layer.shadowOpacity = 0.8
        btn.layer.shadowRadius = 0.4
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.masksToBounds = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(BtnEnter_Click), for: .touchUpInside)
        return btn
    }()
    
    /// A button for password recovery.
    private lazy var btnRecoveryPass: UIButton = {
        let btn = UIButton()
        btn.setTitle("Восстановить пароль".localized, for: .normal)
        btn.setTitleColor(.systemGray, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.accessibilityIdentifier = "btnRecoveryPass"
        btn.addTarget(self, action: #selector(BtnRecoveryPass_Click), for: .touchUpInside)
        return btn
    }()
    
    private lazy var btnShowCode: UIButton = {
        let btn = UIButton()
        btn.setTitle("Код устройства".localized, for: .normal)
        btn.setTitleColor(.systemGray, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.textAlignment = .right
        btn.accessibilityIdentifier = "btnShowCode"
        btn.addTarget(self, action: #selector(btnShowCode_Click), for: .touchUpInside)
        return btn
    }()
    
    private lazy var containerImg: UIView = {
        let view = UIView()
        view.accessibilityIdentifier = "containerImg"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 80
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
    
    /// A table view for user input.
    private lazy var tblAuthentication: UITableView = {
        let tbl = UITableView()
        tbl.accessibilityIdentifier = "tblAuthentication"
        tbl.register(AuthenticationTblViewCell.self, forCellReuseIdentifier: AuthenticationTblViewCell.indificatorCell)
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.dataSource = self
        tbl.delegate = self
        tbl.backgroundColor = .clear
        tbl.separatorStyle = .singleLine
        tbl.isScrollEnabled = false
        tbl.separatorColor = .white
        tbl.allowsSelectionDuringEditing = false
        tbl.layer.cornerRadius = 10
        tbl.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        tbl.clipsToBounds = false
        tbl.rowHeight = ((UIScreen.main.bounds.size.height/2 + tbl.contentOffset.y) / 2 ) / 3
        return tbl
    }()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerForKeyboardNotification()
        apiManagerIndustry = APIManagerIndustry()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        apiManagerIndustry = nil
        print("sucsses closed EnterMenuViewController")
    }
    
    // MARK: - Actions
    
    /// Func click button recovery password
    @objc
    private func BtnRecoveryPass_Click(_ sender: UIButton) {
        let vc = RecovoryPasswordViewController()
        let vcNav = UINavigationController(rootViewController: vc)
        vcNav.modalPresentationStyle = .fullScreen
        navigationController?.present(vcNav, animated: true, completion: nil)
    }
    
    @objc
    private func btnShowCode_Click(_ sender: UIButton) {
        guard let identifier = UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
        let alControl:UIAlertController = {
            let alControl = UIAlertController(title: "Ваш код устройства".localized, message: identifier, preferredStyle: .alert)
            let btnOk: UIAlertAction = {
                let btn = UIAlertAction(title: "Ok".localized,
                                        style: .default,
                                        handler: nil )
                return btn
            }()
            let btnCopy: UIAlertAction = {
                let btn = UIAlertAction(title: "Скопировать код".localized,
                                        style: .default,
                                        handler: {_ in
                                            UIPasteboard.general.string = identifier
                                        })
                return btn
            }()
            alControl.addAction(btnOk)
            alControl.addAction(btnCopy)
            return alControl
        }()
        self.present(alControl, animated: true, completion: nil)
    }
    
    /// Func click button enter to application
    @objc
    private func BtnEnter_Click(_ sender: UIButton) {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.6
        blurEffectView.contentView.addSubview(activityIndicator)
        view.addSubview(blurEffectView)
        
        activityIndicator.startAnimating()
        
        guard let login = usserLogin, let password = usserPassword,
              !login.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlController(messege: "Вы не ввели данные для входа".localized)
            activityIndicator.stopAnimating()
            blurEffectView.removeFromSuperview()
            return
        }
        let authBody = AuthBody(email: login, password: password)
        apiManagerIndustry?.validateCredentials(credentials: authBody) {[weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    activityIndicator.stopAnimating()
                    blurEffectView.removeFromSuperview()
                    let errorsUser = INDNetworkingError.init(error)
                    self.showAlController(messege: errorsUser.errorMessage)
                case .success(let idEmployee):
                    let vc = TabBarController()
                    self.delegete = vc
                    self.delegete?.enterMenuViewController(self, didLoadEmployeeWitch: idEmployee, completion: {
                        let navigationController = UINavigationController(rootViewController: vc)
                        navigationController.modalPresentationStyle = .fullScreen
                        navigationController.isToolbarHidden = true
                        navigationController.isNavigationBarHidden = true
                        activityIndicator.stopAnimating()
                        blurEffectView.removeFromSuperview()
                        self.present(navigationController, animated: true, completion: {
                                    self.delegete = nil
                            NotificationCenter.default.removeObserver(self)
                            self.apiManagerIndustry = nil
                            self.view.willRemoveSubview(self.tblAuthentication)
                            self.view.removeFromSuperview()
                            self.removeFromParent()
                                })
                    }, failer: { error in
                        let errorsUser = INDNetworkingError.init(error)
                        self.showAlController(messege: errorsUser.errorMessage)
                        activityIndicator.stopAnimating()
                        blurEffectView.removeFromSuperview()
                    })
                }
            }
        }
    }
    
    /// Keyboard will show notification handler
    @objc
    private func kbWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if view.frame.origin.y == 0 {
                let keyboardHeight = keyboardFrame.height
                let bottomSpace = view.frame.height - (btnEnter.frame.origin.y + btnEnter.frame.height)
                view.frame.origin.y -= max(0, keyboardHeight - bottomSpace + 10)
            }
        }
    }
    
    /// Keyboard will hide notification handler
    @objc
    private func kbWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    // MARK: - Privates func
    /// Register for keyboard notifications
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    /// Configures the UI elements of the view controller.
    private func configureUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        view.addSubview(tblAuthentication)
        view.addSubview(btnEnter)
        view.addSubview(btnShowCode)
        view.addSubview(containerImg)
        view.addSubview(btnRecoveryPass)
        containerImg.addSubview(imgCompany)
        NSLayoutConstraint.activate([
            // Authentication table view
            tblAuthentication.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tblAuthentication.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tblAuthentication.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.20),
            tblAuthentication.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            tblAuthentication.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            // Enter button
            btnEnter.heightAnchor.constraint(equalToConstant: 40),
            btnEnter.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -190),
            btnEnter.topAnchor.constraint(equalTo: btnRecoveryPass.bottomAnchor, constant: 20),
            btnEnter.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            // Recovery password button
            btnRecoveryPass.topAnchor.constraint(equalTo: tblAuthentication.bottomAnchor, constant: -10),
            btnRecoveryPass.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            // Show Code button
            btnShowCode.topAnchor.constraint(equalTo: tblAuthentication.bottomAnchor, constant: -10),
            btnShowCode.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            // Company logo
            containerImg.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            containerImg.heightAnchor.constraint(equalTo: containerImg.widthAnchor),
            containerImg.bottomAnchor.constraint(equalTo: tblAuthentication.topAnchor, constant: -(UIScreen.main.bounds.height/2 + tblAuthentication.contentOffset.y) / 12),
            containerImg.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imgCompany.topAnchor.constraint(equalTo: containerImg.topAnchor, constant: 15),
            imgCompany.leadingAnchor.constraint(equalTo: containerImg.leadingAnchor, constant: 15),
            imgCompany.trailingAnchor.constraint(equalTo: containerImg.trailingAnchor, constant: -15),
            imgCompany.bottomAnchor.constraint(equalTo: containerImg.bottomAnchor, constant: -15),
        ])
    }
}

// MARK: - Table View Data Source
extension EnterMenuViewController: UITableViewDataSource {
    
    /// Returns the number of rows in the table view section.
    /// - Parameter tableView: The table view requesting this information.
    /// - Parameter section: An index number identifying a section of `tableView`.
    /// - Returns: The number of rows in section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    /// Asks the data source for a cell to insert in a particular location of the table view.
    /// - Parameter tableView: A table-view object requesting the cell.
    /// - Parameter indexPath: An index path locating a row in `tableView`.
    /// - Returns: An object inheriting from `UITableViewCell` that the table view can use for the specified row. An assertion is raised if you return nil.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AuthenticationTblViewCell.indificatorCell, for: indexPath) as? AuthenticationTblViewCell else {
            fatalError("Unable to dequeue cell.")
        }
        let row = AuthenticationTableRow(rawValue: indexPath.row)!
        switch indexPath.row {
        case 0:
            cell.accessibilityIdentifier = "cellLogin"
        case 1:
            cell.accessibilityIdentifier = "cellPassword"
        default:
            break
        }
        cell.fillTable(row.title, row.isSecure)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.delegete = self
        cell.separatorInset = .zero
        return cell
    }
}

// MARK: - Table View Data Source and Table View Delegate
extension EnterMenuViewController: UITableViewDelegate {
}

// MARK: - AuthenticationTblViewCellDelegate
extension EnterMenuViewController: AuthenticationTblViewCellDelegate {
    /// Tells the delegate that the value of the text field has changed.
    /// - Parameter cell: The table view cell that contains the text field.
    /// - Parameter value: The new text for the text field.
    func authenticationTblViewCell(_ cell: AuthenticationTblViewCell, didChanged value: String) {
        if cell.accessibilityIdentifier == "cellLogin" {
            usserLogin = value
        } else if cell.accessibilityIdentifier == "cellPassword" {
            usserPassword = value
        }
        return
    }
}
