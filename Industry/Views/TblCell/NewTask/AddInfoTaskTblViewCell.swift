//
//  AddInfoTaskTblViewCell.swift
//  Industry
//
//  Created by  Даниил on 23.05.2023.
//

import UIKit

class AddInfoTaskTblViewCell: UITableViewCell {
    // MARK: - Properties
    static let indificatorCell = "AddInfoTaskTblViewCell"
    
    // MARK: - Private UI
    /// A UIView container image
    private lazy var containerIcon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.masksToBounds = false
        return view
    }()

    /// A UIImageView  image user
    private lazy var imgIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var txtFld: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textColor = .white
        txt.font = UIFont(name: "San Francisco", size: 20)
        txt.textAlignment = .left
        txt.delegate = self
        return txt
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    /**
     Fills the table view cell with the given add task item palcholder and icon name.
     
     - Parameter palcholder: The palcholder of the add task item to display.
     - Parameter iconName: The name of the image to use as the add task item icon.
     */
    func fiillTable(_ palcholder: String, _ iconName: UIImage?) {
        txtFld.placeholder = palcholder
        imgIcon.image = iconName
    }
    
    // MARK: - Private func
    private func configureUI() {
        self.contentView.addSubview(containerIcon)
        self.contentView.addSubview(txtFld)
        containerIcon.addSubview(imgIcon)
        NSLayoutConstraint.activate([
            containerIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            containerIcon.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            containerIcon.heightAnchor.constraint(equalTo: containerIcon.widthAnchor, multiplier: 1.0),
            containerIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            txtFld.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            txtFld.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            txtFld.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            txtFld.leadingAnchor.constraint(equalTo: imgIcon.trailingAnchor, constant: 10),
            txtFld.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            imgIcon.topAnchor.constraint(equalTo: containerIcon.topAnchor, constant: 5),
            imgIcon.leadingAnchor.constraint(equalTo: containerIcon.leadingAnchor, constant: 5),
            imgIcon.trailingAnchor.constraint(equalTo: containerIcon.trailingAnchor, constant: -5),
            imgIcon.bottomAnchor.constraint(equalTo: containerIcon.bottomAnchor, constant: -5),
        ])
    }
}

// MARK: Text Field Delegate
extension AddInfoTaskTblViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFld {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}
