//
//  EnterMenuViewController.swift
//  Industry
//
//  Created by birdus on 24.02.2023.
//

import UIKit


class EnterMenuViewController: UIViewController {
    
    private lazy var btnEnter: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.systemPurple
        btn.setTitle("Войти".localized, for: .normal)
        btn.setTitleColor(.systemGray4, for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        btn.clipsToBounds = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(BtnEnter_Click), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var btnRecoveryPass: UIButton = {
        let btn = UIButton()
        btn.setTitle("Восстановить пароль".localized, for: .normal)
        btn.setTitleColor(.systemGray, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(BtnRecoveryPass_Click), for: .touchUpInside)
        return btn
    }()
    
    private lazy var imgCompany: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "logoCompany.jpg")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func BtnRecoveryPass_Click(_ sender: UIButton) {
        
    }
    
    
    @objc
    private func BtnEnter_Click(_ sender: UIButton) {
        let mainTabBarController = MenuTabBarController()
//                vc.delegate = self
        let vcNav = UINavigationController(rootViewController: mainTabBarController)
        vcNav.modalPresentationStyle = .fullScreen
        present(vcNav , animated: true)

    }
    
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
    
    @objc
    private func kbWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
        
    }
    
    private func         registerForKeyboardNotifacation() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureUI() {
        // TODO: The function is responsible for setting the UI
            view.backgroundColor = .white
            view.addSubview(tblAuthentication)
            view.addSubview(btnEnter)
            view.addSubview(imgCompany)
            view.addSubview(btnRecoveryPass)
            navigationController?.setNavigationBarHidden(true, animated: false)
            registerForKeyboardNotifacation()
            NSLayoutConstraint.activate([
                tblAuthentication.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                       tblAuthentication.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                       tblAuthentication.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25),
                       tblAuthentication.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
                       tblAuthentication.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                       
                       btnEnter.heightAnchor.constraint(equalToConstant: 40),
                       btnEnter.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -80),
                       btnEnter.topAnchor.constraint(equalTo: btnRecoveryPass.bottomAnchor, constant: 40),
                       btnEnter.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                       
                       btnRecoveryPass.topAnchor.constraint(equalTo: tblAuthentication.bottomAnchor, constant: -4),
                       btnRecoveryPass.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                       
                       imgCompany.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -150),
                       imgCompany.heightAnchor.constraint(equalTo: imgCompany.widthAnchor),
                       imgCompany.bottomAnchor.constraint(equalTo: tblAuthentication.topAnchor, constant: -(UIScreen.main.bounds.height/2 + tblAuthentication.contentOffset.y) / 8),
                       imgCompany.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            ])
        tblAuthentication.rowHeight = ((UIScreen.main.bounds.size.height/2 + tblAuthentication.contentOffset.y) / 2 ) / 2
           btnRecoveryPass.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10)/2)
           btnEnter.titleLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10)/2, weight: .bold)
    }
}

extension EnterMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AuthenticationTblViewCell.indificatorCell, for: indexPath) as? AuthenticationTblViewCell else {
                fatalError("Unable to dequeue cell.")
            }
            let row = AuthenticationTableRow(rawValue: indexPath.row)!
            cell.fillTable(row.imageName, row.title, row.isSecure)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.delegete = self
            cell.separatorInset = .zero
            return cell
    }
}

extension EnterMenuViewController: AuthenticationTblViewCellDelegate {
    func authenticationTblViewCell(_ cell: AuthenticationTblViewCell, didChanged value: String) {
        return
    }
}
