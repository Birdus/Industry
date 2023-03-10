//
//  AuthenticationTblViewCell.swift
//  Industry
//
//  Created by birdus on 25.02.2023.
//

import UIKit

protocol AuthenticationTblViewCellDelegate: AnyObject {
    func authenticationTblViewCell(_ cell: AuthenticationTblViewCell, didChanged value: String)
}

class AuthenticationTblViewCell: UITableViewCell {
    
    static let indificatorCell: String = "AuthenticationTblViewCell"
    weak var delegete: AuthenticationTblViewCellDelegate!
    
    private lazy var imgEnterIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private lazy var txtFld: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        var tlBarTxt: UIToolbar = {
            let tlBar = UIToolbar()
            let btnDone = UIBarButtonItem(title: "Готово".localized, style: UIBarButtonItem.Style.done, target: self, action: #selector(btnDone_Click))
            let btnCancel = UIBarButtonItem(title: "Отменить".localized, style: UIBarButtonItem.Style.plain, target: self, action: #selector(btnCancel_click))
            let btnSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            tlBar.setItems([btnCancel, btnSpace, btnDone], animated: true)
            tlBar.sizeToFit()
            return tlBar
        }()
        txt.textColor = .black
        txt.font = UIFont(name: "San Francisco", size: 20)
        txt.isSecureTextEntry = true
        txt.inputAccessoryView = tlBarTxt
        txt.textAlignment = .left
        txt.delegate = self
        return txt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func fillTable(_ iconName: String, _ placeholder: String, _ isPasword: Bool) {
        imgEnterIcon.image = UIImage(named: iconName)
        txtFld.placeholder = placeholder
        txtFld.isSecureTextEntry = isPasword
    }
    
    @objc
    private func btnDone_Click(_ sender: UIBarButtonItem) {
        delegete.authenticationTblViewCell(self, didChanged: txtFld.text!)
        contentView.endEditing(true)
    }
    
    @objc
    private func btnCancel_click(_ sender: UIBarButtonItem) {
        contentView.endEditing(true)
    }
    
    private func configureUI() {
        contentView.addSubview(imgEnterIcon)
        contentView.addSubview(txtFld)
        contentView.addSubview(imgEnterIcon)
        NSLayoutConstraint.activate([
            imgEnterIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imgEnterIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imgEnterIcon.heightAnchor.constraint(equalToConstant: (self.contentScaleFactor + UIScreen.main.bounds.size.height/2) / 10),
            imgEnterIcon.widthAnchor.constraint(equalToConstant: (self.contentScaleFactor + UIScreen.main.bounds.size.height/2) / 10),
            txtFld.heightAnchor.constraint(equalTo: self.heightAnchor),
            txtFld.leadingAnchor.constraint(equalTo: imgEnterIcon.trailingAnchor, constant: 6),
            txtFld.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            txtFld.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        txtFld.font = UIFont.systemFont(ofSize: CGFloat(self.bounds.height/2))
    }
    
    
}

extension AuthenticationTblViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegete.authenticationTblViewCell(self, didChanged: txtFld.text!)
    }
}
