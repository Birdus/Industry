//
//  UserDescriptionCollViewCell.swift
//  Industry
//
//  Created by Даниил on 14.03.2023.
//

import UIKit
// MARK: - UserDescriptionCollViewCell

/**
 A UICollectionViewCell subclass used to display user information in a UICollectionView.
 */
class UserDescriptionCollViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    /// A string value to identify the cell when registering with the UICollectionView.
    static let indificatorCell: String = "UserDescriptionCollViewCell"
    
    /// A UILabel displaying the first name of the user.
    lazy private var lblFirstName: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    /// A UILabel displaying the second name of the user.
    lazy private var lblSecondName: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    /// A UILabel displaying the last name of the user.
    lazy private var lblLastName: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .right
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    /// A UILabel displaying the role of the user.
    lazy private var lblRoleUser: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    /// A UILabel displaying the division of the user.
    lazy private var lblDivisionUser: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    /// A UILabel displaying the service number of the user.
    lazy private var lblServiceNumber: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    /**
     Fills the labels with user information.
     - Parameter firstName: A string representing the user's first name.
     - Parameter secondName: A string representing the user's second name.
     - Parameter lastName: A string representing the user's last name.
     - Parameter roleUser: A string representing the user's role.
     - Parameter devisionUser: A string representing the user's division.
     - Parameter serviceNumber: An integer representing the user's service number.
     */
    public func fillTable(_ firstName: String, _ secondName: String, _ lastName: String, _ roleUser: String, _ devisionUser: String, _ serviceNumber: Int) {
        lblLastName.text = lastName
        lblRoleUser.text = "Должность: " + roleUser
        lblFirstName.text = firstName
        lblSecondName.text = secondName
        lblDivisionUser.text = "Подразделения: " + devisionUser
        lblServiceNumber.text = "Табельный номер: " + String(serviceNumber)
    }
    
    // MARK: - Private Methods
    /// Configures the cell's user interface.
    private func configureUI () {
        contentView.addSubview(lblFirstName)
        contentView.addSubview(lblSecondName)
        contentView.addSubview(lblLastName)
        contentView.addSubview(lblRoleUser)
        contentView.addSubview(lblDivisionUser)
        contentView.addSubview(lblServiceNumber)
        contentView.layoutMargins.top = 0
        NSLayoutConstraint.activate([
            lblFirstName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            lblFirstName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            lblSecondName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            lblSecondName.leadingAnchor.constraint(equalTo: lblFirstName.trailingAnchor, constant: 10),
            
            lblLastName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            lblLastName.leadingAnchor.constraint(equalTo: lblSecondName.trailingAnchor, constant: 10),
            
            lblDivisionUser.topAnchor.constraint(greaterThanOrEqualTo: contentView.safeAreaLayoutGuide.centerYAnchor, constant: -35),
            lblDivisionUser.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            lblRoleUser.topAnchor.constraint(equalTo: lblDivisionUser.bottomAnchor, constant: 10),
            lblRoleUser.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            lblServiceNumber.topAnchor.constraint(equalTo: lblRoleUser.bottomAnchor, constant: 10),
            lblServiceNumber.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        let lblSizeFont = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10)/2)
        lblFirstName.font = lblSizeFont
        lblSecondName.font = lblSizeFont
        lblLastName.font = lblSizeFont
        lblDivisionUser.font = lblSizeFont
        lblRoleUser.font = lblSizeFont
        lblServiceNumber.font = lblSizeFont
    }
}
