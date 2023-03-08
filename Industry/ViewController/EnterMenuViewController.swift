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
        btn.backgroundColor = UIColor.blue
        btn.setTitle("Войти", for: .normal )
        btn.setTitleColor(.systemGray4, for: .normal)
        btn.titleShadowColor(for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(BtnEnter_Click), for: .touchUpInside)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .systemPurple
        btn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        btn.layer.masksToBounds = true
        
        btn.layer.shadowColor = UIColor.darkGray.cgColor;
        btn.layer.shadowOffset = CGSize(width: 1.0, height: 1.0);
        btn.layer.shadowOpacity = 1.4;
        btn.layer.shadowRadius = 5.0;
        btn.clipsToBounds = false;
        btn.layer.masksToBounds = false;

        return btn
    }()
    
    
    private lazy var btnRecoveryPass: UIButton = {
        let btn = UIButton()
        btn.setTitle("Востановить пароль", for: .normal )
        btn.setTitleColor(.systemGray, for: .normal)
        btn.titleShadowColor(for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(BtnRecoveryPass_Click), for: .touchUpInside)
        btn.backgroundColor = .clear
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
        tbl.separatorEffect = .none
        tbl.separatorInset = .zero
        tbl.separatorInsetReference = .fromCellEdges
        tbl.allowsSelectionDuringEditing = false
        tbl.layer.masksToBounds = true
        
        tbl.layer.shadowColor = UIColor.darkGray.cgColor;
        tbl.layer.shadowOffset = CGSize(width: 1.0, height: 1.0);
        tbl.layer.shadowOpacity = 0.4;
        tbl.layer.shadowRadius = 5.0;
        tbl.clipsToBounds = false;
        tbl.layer.masksToBounds = false;
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
        
    }
    
    @objc
    private func kbWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if self.view.frame.origin.y == 0 {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                let bottomSpace = self.view.frame.height - (btnEnter.frame.origin.y + btnEnter.frame.height)
                self.view.frame.origin.y -= keyboardHeight - bottomSpace + 10
            }
        }
    }
    
    @objc
    private func kbWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
        
    }
    
    
    private func registerForKeyboardNotifacation() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func gradientBackground() -> CAGradientLayer{
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        let colorTop = UIColor(red: 42.0/255.0, green: 152.0/255.0, blue: 253.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 121.0/255.0, green: 129.0/255.0, blue: 249.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop ,colorBottom]
        gradientLayer.locations = [0.0 ,1.1]
        gradientLayer.frame = self.view.bounds
        return gradientLayer
    }
    
    
    private func configureUI() {
        // TODO: The function is responsible for setting the UI
        view.backgroundColor = .white
        view.addSubview(tblAuthentication)
        view.addSubview(btnEnter)
        view.addSubview(imgCompany)
        view.addSubview(btnRecoveryPass)
//        view.layer.insertSublayer(gradientBackground(), at: 0)
        registerForKeyboardNotifacation()
        NSLayoutConstraint.activate([
            tblAuthentication.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tblAuthentication.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tblAuthentication.heightAnchor.constraint(equalToConstant: (CGFloat(CGPoint(x: UIScreen.main.bounds.size.width/2, y: (UIScreen.main.bounds.size.height/2 + tblAuthentication.contentOffset.y)).y)) / 2),
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
            imgCompany.widthAnchor.constraint(equalToConstant: 100),
            imgCompany.bottomAnchor.constraint(equalTo: tblAuthentication.topAnchor, constant: -(tblAuthentication.bounds.height / 3)),
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
        guard let cell = tblAuthentication.dequeueReusableCell(withIdentifier: AuthenticationTblViewCell.indificatorCell, for: indexPath) as?
                AuthenticationTblViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.backgroundView?.isHidden = true;
        switch indexPath.row {
        case 0:
            cell.fillTable("testLog", "Логин", false)
            cell.delegete = self
        case 1:
            cell.fillTable("testPas", "Пароль", true)
            cell.delegete = self
            cell.separatorInset = .zero
            
        default:
            cell.fillTable("", "", false)
        }
        return cell
    }
}

extension EnterMenuViewController: AuthenticationTblViewCellDelegate {
    func authenticationTblViewCell(_ cell: AuthenticationTblViewCell, didChanged value: String) {
        return
    }
}
