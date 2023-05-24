//
//  EditEmployeeTaskTblViewCell.swift
//  Industry
//
//  Created by  Даниил on 24.05.2023.
//

import UIKit

class EditEmployeeTaskTblViewCell: UITableViewCell {
    // MARK: - Properties
    static let indificatorCell = "EditEmployeeTaskTblViewCell"
    
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
    
    private lazy var lblEmployee: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.font = UIFont(name: "San Francisco", size: CGFloat(UIScreen.main.bounds.width/10)/2)
        lbl.textAlignment = .left
        return lbl
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
        lblEmployee.text = palcholder
        imgIcon.image = iconName
        lblEmployee.textColor = UIColor.lightGray
    }
    
    // MARK: - Private func
    private func configureUI() {
        self.contentView.addSubview(containerIcon)
        self.contentView.addSubview(lblEmployee)
        containerIcon.addSubview(imgIcon)
        NSLayoutConstraint.activate([
            containerIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            containerIcon.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            containerIcon.heightAnchor.constraint(equalTo: containerIcon.widthAnchor, multiplier: 1.0),
            containerIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            lblEmployee.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lblEmployee.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            lblEmployee.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            lblEmployee.leadingAnchor.constraint(equalTo: imgIcon.trailingAnchor, constant: 10),
            lblEmployee.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            imgIcon.topAnchor.constraint(equalTo: containerIcon.topAnchor, constant: 5),
            imgIcon.leadingAnchor.constraint(equalTo: containerIcon.leadingAnchor, constant: 5),
            imgIcon.trailingAnchor.constraint(equalTo: containerIcon.trailingAnchor, constant: -5),
            imgIcon.bottomAnchor.constraint(equalTo: containerIcon.bottomAnchor, constant: -5),
        ])
    }
}
