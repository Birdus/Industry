//
//  AuthenticationTblViewCell.swift
//  Industry
//
//  Created by birdus on 25.02.2023.
//
// MARK: - Authentication Table View Cell

/**
 A table view cell that displays a secure text field for authentication purposes.
 
 Important Notes
 - This cell is used to display a secure text field for authentication purposes.
 - The cell has a delegate that notifies when the text field text has changed.
 Example Usage
 
 let cell = tableView.dequeueReusableCell(withIdentifier: AuthenticationTblViewCell.indificatorCell, for: indexPath) as! AuthenticationTblViewCell
 cell.fillTable("Password", true)
 cell.delegete = self
 
 Note: This cell is used to display a secure text field for authentication purposes.
 */
import UIKit

/// The AuthenticationTblViewCellDelegate protocol defines methods that a delegate of the AuthenticationTblViewCell can use to receive notifications when the text in the text field is changed.
protocol AuthenticationTblViewCellDelegate: AnyObject {
    /// Tells the delegate that the text in the text field is changed.
    /// - Parameter cell: The AuthenticationTblViewCell whose text field's value changed.
    /// - Parameter value: The new value of the text field.
    func authenticationTblViewCell(_ cell: AuthenticationTblViewCell, didChanged value: String)
}

class AuthenticationTblViewCell: UITableViewCell {
    // MARK: Properties
    /// The reuse identifier for the cell.
    static let indificatorCell: String = "AuthenticationTblViewCell"
    
    /// The delegate for handling changes in text input.
    weak var delegete: AuthenticationTblViewCellDelegate!
    
    /// The text field for user input.
    private lazy var txtFld: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textColor = .black
        txt.font = UIFont(name: "San Francisco", size: 20)
        txt.isSecureTextEntry = true
        txt.textAlignment = .left
        txt.delegate = self
        return txt
    }()
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    /// Configures the cell with a placeholder and whether the input should be a password field.
    public func fillTable(_ placeholder: String, _ isPasword: Bool) {
        txtFld.placeholder = placeholder
        txtFld.isSecureTextEntry = isPasword
    }
    
    // MARK: Private Methods
    /// Handles the "Done" button being pressed on the keyboard accessory view.
    @objc private func btnDone_Click(_ sender: UIBarButtonItem) {
        delegete.authenticationTblViewCell(self, didChanged: txtFld.text!)
        contentView.endEditing(true)
    }
    
    /// Handles the "Cancel" button being pressed on the keyboard accessory view.
    @objc private func btnCancel_click(_ sender: UIBarButtonItem) {
        contentView.endEditing(true)
    }
    
    /// Configures the cell's user interface.
    private func configureUI() {
        contentView.addSubview(txtFld)
        NSLayoutConstraint.activate([
            txtFld.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            txtFld.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            txtFld.topAnchor.constraint(equalTo: contentView.topAnchor),
            txtFld.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        txtFld.font = UIFont.systemFont(ofSize: contentView.bounds.height/2)
    }
}

// MARK: Text Field Delegate
extension AuthenticationTblViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFld {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let value = textField.text {
            if !value.isNullOrWhiteSpace {
                delegete.authenticationTblViewCell(self, didChanged: value)
            }
        }
    }
}
