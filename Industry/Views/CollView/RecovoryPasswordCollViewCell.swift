//
//  CollectionViewCell.swift
//  Industry
//
//  Created by  Даниил on 22.04.2023.
//

import UIKit

class RecovoryPasswordCollViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    /// The identifier for this collection view cell
    static let indificatorCell: String = "CollectionViewCell"
    
    // MARK: - UI Elements
    
    /// A label to show the heading of the password recovery screen.
    private lazy var lblHead: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.text = "Востановления пароля".localized
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: frame.height / 10, weight: .bold)
        return lbl
    }()
    
    /// A label to show the description of the password recovery screen.
    private lazy var lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.text = "Введите свой логин который используеться на вашем акаунте".localized
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: frame.height / 14)
        return lbl
    }()
    
    /// A text field to input the login of the user.
    private lazy var txtFldLogin: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textColor = .black
        txt.textAlignment = .left
        txt.delegate = self
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIScreen.main.bounds.width / 16)]
        txt.attributedPlaceholder = NSAttributedString(string: "Логин".localized, attributes: attributes)
        txt.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width / 16)
        return txt
    }()
    
    /// A text field to input the new password of the user.
    private lazy var txtNewPassword: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textColor = .black
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIScreen.main.bounds.width / 16)]
        txt.attributedPlaceholder = NSAttributedString(string: "Новый пароль".localized, attributes: attributes)
        txt.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width / 16)
        txt.textAlignment = .left
        txt.delegate = self
        return txt
    }()
    
    /// A text field to confirm the new password of the user.
    private lazy var txtConfirmeNewPassword: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textColor = .black
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIScreen.main.bounds.width / 16)]
        txt.attributedPlaceholder = NSAttributedString(string: "Подтвердите пароль".localized, attributes: attributes)
        txt.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width / 16)
        txt.textAlignment = .left
        txt.delegate = self
        return txt
    }()
    
    /// A text field to input the verification code received by the user.
    private lazy var txtFldCode: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textColor = .black
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIScreen.main.bounds.width / 16)]
        txt.attributedPlaceholder = NSAttributedString(string: "-   -   -   -   -".localized, attributes: attributes)
        txt.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width / 16)
        txt.keyboardType = .numberPad
        txt.textAlignment = .center
        txt.delegate = self
        txt.addTarget(self, action: #selector(codeEntered), for: .editingChanged)
        return txt
    }()
    
    /// A button for password recovery.
    private lazy var btnRecoveryPass: UIButton = {
        let btn = UIButton()
        btn.setTitle("Восстановить пароль".localized, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(btnRecoveryPass_Click), for: .touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        btn.clipsToBounds = false
        return btn
    }()
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func btnRecoveryPass_Click(_ sender: UIButton) {
        addSubview(txtFldCode)
        NSLayoutConstraint.activate([
            txtFldCode.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            txtFldCode.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            txtFldCode.topAnchor.constraint(equalTo: lblDescription.bottomAnchor, constant: 10),
            btnRecoveryPass.topAnchor.constraint(equalTo: txtFldCode.bottomAnchor, constant: 20)
        ])
        let currentFrame = txtFldLogin.frame
        btnRecoveryPass.setTitle("Подтвердить код".localized, for: .normal)
        txtFldLogin.frame.origin.y += currentFrame.height
        let animator = UIViewPropertyAnimator(duration: 0.0, curve: .easeInOut) {
            self.txtFldCode.frame = currentFrame
            self.txtFldLogin.alpha = 0.0
            self.lblDescription.text = "Введите код, который пришел на вашу электронную почту".localized
            self.btnRecoveryPass.removeTarget(self, action: #selector(self.btnRecoveryPass_Click), for: .touchUpInside)
            self.btnRecoveryPass.addTarget(self, action: #selector(self.acceptCodeClick), for: .touchUpInside)
            self.layoutIfNeeded()
        }
        animator.addCompletion { _ in
            self.txtFldLogin.removeFromSuperview()
        }
        animator.startAnimation()
    }
    
    @objc private func acceptCodeClick(_ sender: UIBarButtonItem) {
        addSubview(txtNewPassword)
        addSubview(txtConfirmeNewPassword)
        NSLayoutConstraint.activate([
            txtNewPassword.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            txtNewPassword.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            txtNewPassword.topAnchor.constraint(equalTo: lblDescription.bottomAnchor, constant: 10),
            txtConfirmeNewPassword.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            txtConfirmeNewPassword.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            txtConfirmeNewPassword.topAnchor.constraint(equalTo: txtNewPassword.bottomAnchor, constant: 10),
            
            btnRecoveryPass.topAnchor.constraint(equalTo: txtConfirmeNewPassword.bottomAnchor, constant: 20)
        ])
        btnRecoveryPass.setTitle("Сменить пароль".localized, for: .normal)
        let currentFrame = txtFldCode.frame
        txtNewPassword.frame.origin.y += currentFrame.height
        let animator = UIViewPropertyAnimator(duration: 0.0, curve: .easeInOut) {
            self.txtNewPassword.frame = currentFrame
            self.txtFldLogin.alpha = 0.0
            self.lblDescription.text = "Введите новый пароль и подтвердите".localized
            self.btnRecoveryPass.removeTarget(self, action: #selector(self.acceptCodeClick), for: .touchUpInside)
            self.btnRecoveryPass.addTarget(self, action: #selector(self.changePassword_Click), for: .touchUpInside)
            self.layoutIfNeeded()
        }
        animator.addCompletion { _ in
            self.txtFldCode.removeFromSuperview()
        }
        animator.startAnimation()
    }
    
    @objc
    private func changePassword_Click(_ sender: UIBarButtonItem) {
        
    }
    
    @objc
    func codeEntered(_ textField: UITextField) {
        guard let code = textField.text else { return }
        switch code.count {
        case 8...Int.max:
            textField.deleteBackward()
        case 7:
            textField.resignFirstResponder()
            print("Код: \(code)")
        case 3:
            textField.text?.append(" ")
        default:
            break
        }
    }

    // MARK: - Private Methods
    /// Configures the cell's user interface.
    private func configureUI () {
        self.addSubview(lblHead)
        self.addSubview(txtFldLogin)
        self.addSubview(lblDescription)
        self.addSubview(btnRecoveryPass)
        let guide = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            lblHead.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10),
            lblHead.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            lblHead.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),
            lblHead.heightAnchor.constraint(equalToConstant: self.frame.height / 6),
            
            lblDescription.topAnchor.constraint(equalTo: lblHead.bottomAnchor, constant: 10),
            lblDescription.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            lblDescription.bottomAnchor.constraint(equalTo: txtFldLogin.topAnchor, constant: -10),
            lblDescription.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),
            
            txtFldLogin.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            txtFldLogin.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),
            txtFldLogin.bottomAnchor.constraint(equalTo: btnRecoveryPass.topAnchor, constant: -30),
            
            btnRecoveryPass.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -10),
            btnRecoveryPass.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.8),
            btnRecoveryPass.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
        ])
    }
}

// MARK: - UITextFieldDelegate
extension RecovoryPasswordCollViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}



