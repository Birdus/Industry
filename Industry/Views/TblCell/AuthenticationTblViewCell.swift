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
        
    private lazy var txtFld: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        
        // Create the toolbar only once
        let tlBar = UIToolbar()
        let btnDone = UIBarButtonItem(title: "Готово".localized, style: .done, target: self, action: #selector(btnDone_Click))
        let btnCancel = UIBarButtonItem(title: "Отменить".localized, style: .plain, target: self, action: #selector(btnCancel_click))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        tlBar.setItems([btnCancel, btnSpace, btnDone], animated: true)
        tlBar.sizeToFit()
        txt.inputAccessoryView = tlBar
        
        txt.textColor = .black
        txt.font = UIFont(name: "San Francisco", size: 20)
        txt.isSecureTextEntry = true
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
    
    public func fillTable(_ placeholder: String, _ isPasword: Bool) {
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
        contentView.addSubview(txtFld)
            NSLayoutConstraint.activate([
                txtFld.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                txtFld.topAnchor.constraint(equalTo: contentView.topAnchor),
                txtFld.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])

            txtFld.font = UIFont.systemFont(ofSize: contentView.bounds.height/2)
    }


    
}

extension AuthenticationTblViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegete.authenticationTblViewCell(self, didChanged: txtFld.text!)
    }
}
