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
class EnterMenuViewController: UIViewController {
    
    // MARK: - Properties
    /// A button for entering the app.
    private lazy var btnEnter: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("Войти".localized, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        btn.clipsToBounds = false
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
        btn.addTarget(self, action: #selector(BtnRecoveryPass_Click), for: .touchUpInside)
        return btn
    }()
    
    /// An image view displaying the company logo.
    private lazy var imgCompany: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "logoCompany.png")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    /// A table view for user input.
    private lazy var tblAuthentication: UITableView = {
        let tbl = UITableView()
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
        return tbl
    }()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    /// Func click button recovery password
    @objc
    private func BtnRecoveryPass_Click(_ sender: UIButton) {
        let vc = RecovoryPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Func click button enter to application
    @objc
    private func BtnEnter_Click(_ sender: UIButton) {
        let vc = MenuTabBarController()
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isToolbarHidden = true
        navigationController.isNavigationBarHidden = true
        present(navigationController, animated: true, completion: nil)
        
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
    
    // MARK: - Keyboard Notifications
    /// Register for keyboard notifications
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Privates func
    /// Configures the UI elements of the view controller.
    private func configureUI() {
        // TODO: The function is responsible for setting the UI
        // Set background color
        view.backgroundColor = .white
        // Add subviews
        view.addSubview(tblAuthentication)
        view.addSubview(btnEnter)
        view.addSubview(imgCompany)
        view.addSubview(btnRecoveryPass)

        // Hide the navigation bar
        self.navigationController?.isNavigationBarHidden = true
        
        // Register for keyboard notifications
        registerForKeyboardNotification()
        
        // Activate constraints
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
            btnEnter.topAnchor.constraint(equalTo: btnRecoveryPass.bottomAnchor, constant: 40),
            btnEnter.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            // Recovery password button
            btnRecoveryPass.topAnchor.constraint(equalTo: tblAuthentication.bottomAnchor, constant: -4),
            btnRecoveryPass.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            // Company logo
            imgCompany.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -150),
            imgCompany.heightAnchor.constraint(equalTo: imgCompany.widthAnchor),
            imgCompany.bottomAnchor.constraint(equalTo: tblAuthentication.topAnchor, constant: -(UIScreen.main.bounds.height/2 + tblAuthentication.contentOffset.y) / 12),
            imgCompany.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        // Set row height for authentication table view
        tblAuthentication.rowHeight = ((UIScreen.main.bounds.size.height/2 + tblAuthentication.contentOffset.y) / 2 ) / 3
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
        return
    }
}
