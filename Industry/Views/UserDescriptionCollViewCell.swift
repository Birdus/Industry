//
//  UserDescriptionCollViewCell.swift
//  Industry
//
//  Created by Даниил on 14.03.2023.
//

import UIKit

class UserDescriptionCollViewCell: UICollectionViewCell {
    
    static let indificatorCell: String = "UserDescriptionCollViewCell"
    
    lazy private var lblFirstName: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    lazy private var lblSecondName: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    lazy private var lblLastName: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .right
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    lazy private var lblRoleUser: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    lazy private var lblDivisionUser: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    lazy private var lblServiceNumber: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            configureUI ()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func fillTable(_ firstName: String, _ secondName: String ,_ lastName: String, _ roleUser: String, _ devisionUser: String, _ serviceNumber: Int) {
        lblLastName.text = lastName
        lblRoleUser.text = "Должность: " + roleUser
        lblFirstName.text = firstName
        lblSecondName.text = secondName
        lblDivisionUser.text = "Подразделения: " + devisionUser
        lblServiceNumber.text = "Табельный номер: " + String(serviceNumber)
    }
    
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
