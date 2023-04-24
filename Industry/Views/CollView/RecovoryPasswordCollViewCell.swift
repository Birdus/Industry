//
//  CollectionViewCell.swift
//  Industry
//
//  Created by  Даниил on 22.04.2023.
//

import UIKit

class RecovoryPasswordCollViewCell: UICollectionViewCell {
    static let indificatorCell: String = "CollectionViewCell"
    
    private lazy var lblHead: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.text = "Востановления пароля".localized
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: CGFloat(self.frame.height/10), weight: .bold)
        return lbl
    }()
    
    private lazy var lblDescription: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.text = "Введите свой логин который используеться на вашем акаунте".localized
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: CGFloat(self.frame.height/12))
        return lbl
    }()
    
    private lazy var txtFldLogin: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        // Create the toolbar only once
        let tlBar = UIToolbar()
        let btnDone = UIBarButtonItem(title: "Готово".localized, style: .done, target: self, action: #selector(btnDone_Click))
        let btnCancel = UIBarButtonItem(title: "Отменить".localized, style: .plain, target: self, action: #selector(btnCancel_click))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        tlBar.setItems([btnCancel, btnSpace, btnDone], animated: true)
        tlBar.sizeToFit()
        txt.placeholder = "Логин".localized
        txt.inputAccessoryView = tlBar
        txt.textColor = .black
        txt.font = UIFont(name: "San Francisco", size: UIScreen.main.bounds.width/10)
        txt.textAlignment = .left
        
        return txt
    }()
    
    private lazy var txtFldCode: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        // Create the toolbar only once
        let tlBar = UIToolbar()
        let btnDone = UIBarButtonItem(title: "Готово".localized, style: .done, target: self, action: #selector(btnDone_Click))
        let btnCancel = UIBarButtonItem(title: "Отменить".localized, style: .plain, target: self, action: #selector(btnCancel_click))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        tlBar.setItems([btnCancel, btnSpace, btnDone], animated: true)
        tlBar.sizeToFit()
        txt.placeholder = "Код".localized
        txt.inputAccessoryView = tlBar
        txt.textColor = .black
        txt.font = UIFont(name: "San Francisco", size: UIScreen.main.bounds.width/10)
        txt.textAlignment = .left
        return txt
    }()
    
    /// A button for password recovery.
    private lazy var btnRecoveryPass: UIButton = {
        let btn = UIButton()
        btn.setTitle("Восстановить пароль".localized, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(BtnRecoveryPass_Click), for: .touchUpInside)
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
    /// Func click button recovery password
    @objc
    private func BtnRecoveryPass_Click(_ sender: UIButton) {
        addSubview(txtFldCode)
        NSLayoutConstraint.activate([
            txtFldCode.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            txtFldCode.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            txtFldCode.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            txtFldCode.topAnchor.constraint(equalTo: lblDescription.bottomAnchor, constant: 10),
        ])
        let currentFrame = txtFldLogin.frame
        let offscreenFrame = CGRect(x: currentFrame.origin.x, y: currentFrame.origin.y + currentFrame.size.height, width: currentFrame.size.width, height: currentFrame.size.height)
        txtFldLogin.frame = offscreenFrame
        let animator = UIViewPropertyAnimator(duration: 0.0, curve: .easeInOut) {
            self.txtFldCode.frame = currentFrame
            self.txtFldLogin.alpha = 0.0
            self.lblDescription.text = "Введите код который пришёл на вашу электронную почту, которую вы узакывали при регистрации".localized
            self.btnRecoveryPass.removeTarget(self, action: #selector(self.BtnRecoveryPass_Click), for: .touchUpInside)
            self.btnRecoveryPass.addTarget(self, action: #selector(self.SendCode_Click), for: .touchUpInside)
            self.layoutIfNeeded()
        }
        animator.addCompletion { _ in
            self.txtFldLogin.removeFromSuperview()
        }
        animator.startAnimation()
    }
    
    @objc
    private func SendCode_Click(_ sender: UIBarButtonItem) {
        contentView.endEditing(true)
    }
    
    /// Handles the "Done" button being pressed on the keyboard accessory view.
    @objc
    private func btnDone_Click(_ sender: UIBarButtonItem) {
        contentView.endEditing(true)
    }
    
    /// Handles the "Cancel" button being pressed on the keyboard accessory view.
    @objc
    private func btnCancel_click(_ sender: UIBarButtonItem) {
        contentView.endEditing(true)
    }
    
    // MARK: - Private Methods
    /// Configures the cell's user interface.
    private func configureUI () {
        self.addSubview(lblHead)
        self.addSubview(txtFldLogin)
        self.addSubview(lblDescription)
        self.addSubview(btnRecoveryPass)
        NSLayoutConstraint.activate([
            lblHead.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            lblHead.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            lblHead.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            lblHead.heightAnchor.constraint(equalToConstant: CGFloat(self.frame.height/6)),
            
            lblDescription.topAnchor.constraint(equalTo: lblHead.bottomAnchor, constant: 10),
            lblDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            lblDescription.heightAnchor.constraint(equalToConstant: CGFloat(self.frame.height/4)),
            lblDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            txtFldLogin.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            txtFldLogin.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            txtFldLogin.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            txtFldLogin.topAnchor.constraint(equalTo: lblDescription.bottomAnchor, constant: 10),
            btnRecoveryPass.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            btnRecoveryPass.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            btnRecoveryPass.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
}
