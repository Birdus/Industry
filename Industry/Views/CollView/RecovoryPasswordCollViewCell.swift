//
//  CollectionViewCell.swift
//  Industry
//
//  Created by  Даниил on 22.04.2023.
//

import UIKit

protocol RecovoryPasswordCollViewCellDelegate: AnyObject {
    func recovoryPasswordCollViewCell(_ viewController: RecovoryPasswordCollViewCell, didChange values: RecovoryPasswordInfo, complition: @escaping () -> Void)
    func recovoryPasswordCollViewCell(_ viewController: RecovoryPasswordCollViewCell, didChange password: String, code: Int)
}

class RecovoryPasswordCollViewCell: UICollectionViewCell {
    // MARK: - Properties
    /// The identifier for this collection view cell
    static let indificatorCell: String = "CollectionViewCell"
    weak var delegete: RecovoryPasswordCollViewCellDelegate!
    
    private var isAutohorizion: Bool!
    private var confirmResetPassword: ConfirmResetPassword?
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
        lbl.text = "Введите свою почту который используеться на вашем акаунте".localized
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
        txt.attributedPlaceholder = NSAttributedString(string: "Почта".localized, attributes: attributes)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc
    private func btnRecoveryPass_Click(_ sender: UIButton) {
        if let value =  txtFldLogin.text, !value.isNullOrWhiteSpace{
            delegete.recovoryPasswordCollViewCell(self, didChange:  RecovoryPasswordInfo.mail(value: value), complition: {
                self.addSubview(self.txtFldCode)
                NSLayoutConstraint.activate([
                    self.txtFldCode.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                    self.txtFldCode.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                    self.txtFldCode.topAnchor.constraint(equalTo: self.lblDescription.bottomAnchor, constant: 10),
                    self.btnRecoveryPass.topAnchor.constraint(equalTo: self.txtFldCode.bottomAnchor, constant: 20)
                ])
                let currentFrame = self.txtFldLogin.frame
                self.btnRecoveryPass.setTitle("Подтвердить код".localized, for: .normal)
                self.txtFldLogin.frame.origin.y += currentFrame.height
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
            })
        } else {
            delegete.recovoryPasswordCollViewCell(self, didChange: RecovoryPasswordInfo.error(messege: "Вы не ввели почту!".localized), complition: {return})
            return
        }
    }
    
    @objc
    private func acceptCodeClick(_ sender: UIBarButtonItem) {
        if let value =  txtFldCode.text, !value.isNullOrWhiteSpace{
            guard let code = Int(value) else {
                delegete.recovoryPasswordCollViewCell(self, didChange: RecovoryPasswordInfo.error(messege: "Не верный формат кода!".localized), complition: {return})
                return
            }
            delegete.recovoryPasswordCollViewCell(self, didChange: RecovoryPasswordInfo.acssesCode(value: code), complition: {
                self.confirmResetPassword = ConfirmResetPassword(confirmationCode: code, newPassword: nil)
                self.addSubview(self.txtNewPassword)
                self.addSubview(self.txtConfirmeNewPassword)
                NSLayoutConstraint.activate([
                    self.txtNewPassword.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                    self.txtNewPassword.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                    self.txtNewPassword.topAnchor.constraint(equalTo: self.lblDescription.bottomAnchor, constant: 10),
                    self.txtConfirmeNewPassword.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                    self.txtConfirmeNewPassword.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                    self.txtConfirmeNewPassword.topAnchor.constraint(equalTo: self.txtNewPassword.bottomAnchor, constant: 10),
                    
                    self.btnRecoveryPass.topAnchor.constraint(equalTo: self.txtConfirmeNewPassword.bottomAnchor, constant: 20)
                ])
                self.btnRecoveryPass.setTitle("Сменить пароль".localized, for: .normal)
                let currentFrame = self.txtFldCode.frame
                self.txtNewPassword.frame.origin.y += currentFrame.height
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
            })
        } else {
            delegete.recovoryPasswordCollViewCell(self, didChange: RecovoryPasswordInfo.error(messege: "Вы не ввели код!".localized), complition: {return})
            return
        }
        
    }
    
    @objc
    private func changePassword_Click(_ sender: UIBarButtonItem) {
        if let newPassword = txtNewPassword.text, let confirmNewPassword = txtConfirmeNewPassword.text, !newPassword.isNullOrWhiteSpace && !confirmNewPassword.isNullOrWhiteSpace{
            if newPassword == confirmNewPassword {
                guard let code = self.confirmResetPassword?.confirmationCode else {
                    delegete.recovoryPasswordCollViewCell(self, didChange: RecovoryPasswordInfo.error(messege: "Код не соответствует!".localized), complition: {return})
                    return
                }
                delegete.recovoryPasswordCollViewCell(self, didChange: newPassword, code: code)
            } else {
                delegete.recovoryPasswordCollViewCell(self, didChange: RecovoryPasswordInfo.error(messege: "Пароли не совпадают!".localized), complition: {return})
            }
        } else {
            delegete.recovoryPasswordCollViewCell(self, didChange: RecovoryPasswordInfo.error(messege: "Вы не ввели новый пароль!".localized), complition: {return})
        }
    }
    
    @objc
    func codeEntered(_ textField: UITextField) {
        guard let code = textField.text else { return }
        switch code.count {
        case 8...Int.max:
            textField.deleteBackward()
        case 7:
            textField.resignFirstResponder()
        default:
            break
        }
    }
    
    // MARK: - Public Methods
    public func fillCell(isAutohorizion: Bool) {
        self.isAutohorizion = isAutohorizion
        configureUI()
    }
    
    // MARK: - Private Methods
    /// Configures the cell's user interface.
    private func configureUI() {
        let guide = self.safeAreaLayoutGuide
        self.addSubview(lblHead)
        self.addSubview(lblDescription)
        
        NSLayoutConstraint.activate([
            lblHead.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10),
            lblHead.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            lblHead.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),
            lblHead.heightAnchor.constraint(equalToConstant: self.frame.height / 6),
            lblDescription.topAnchor.constraint(equalTo: lblHead.bottomAnchor, constant: 10),
            lblDescription.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            lblDescription.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10)
        ])
        

        if let isAutohorizion = isAutohorizion, isAutohorizion {
            self.addSubview(txtFldCode)
            self.addSubview(btnRecoveryPass)
            lblDescription.text = "Введите код, который пришел на вашу электронную почту".localized
            btnRecoveryPass.removeTarget(self, action: #selector(self.btnRecoveryPass_Click), for: .touchUpInside)
            btnRecoveryPass.addTarget(self, action: #selector(self.acceptCodeClick), for: .touchUpInside)
            btnRecoveryPass.setTitle("Подтвердить код".localized, for: .normal)
            NSLayoutConstraint.activate([
                txtFldCode.topAnchor.constraint(equalTo: lblDescription.bottomAnchor, constant: 10),
                txtFldCode.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
                txtFldCode.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),
                btnRecoveryPass.topAnchor.constraint(equalTo: txtFldCode.bottomAnchor, constant: 20),
                btnRecoveryPass.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -10),
                btnRecoveryPass.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.8),
                btnRecoveryPass.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                lblDescription.bottomAnchor.constraint(equalTo: txtFldCode.topAnchor, constant: -10)
            ])
        } else {
            self.addSubview(txtFldLogin)
            self.addSubview(btnRecoveryPass)
            NSLayoutConstraint.activate([
                txtFldLogin.topAnchor.constraint(equalTo: lblDescription.bottomAnchor, constant: 10),
                txtFldLogin.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
                txtFldLogin.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),
                btnRecoveryPass.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -10),
                btnRecoveryPass.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.8),
                btnRecoveryPass.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                lblDescription.bottomAnchor.constraint(equalTo: txtFldLogin.topAnchor, constant: -10)
            ])
        }
    }
}

// MARK: - UITextFieldDelegate
extension RecovoryPasswordCollViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
