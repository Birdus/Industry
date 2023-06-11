// MenuItemTblViewCell.swift
//
// This file contains the implementation of a custom table view cell used to display menu items.
//
// Created by Даниил on 24.04.2023.
//

import UIKit

/// A custom table view cell used to display menu items.
class MenuItemTblViewCell: UITableViewCell {
    
    // MARK: - Properties
    /// The identifier used to register this cell with a table view.
    static let indificatorCell = "MenuItemTblViewCell"
    
    private lazy var imgIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// A UILabel displaying the name of the menu item.
    private lazy var lblName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor.black
        return label
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
     Fills the table view cell with the given menu item name and icon name.
     
     - Parameter itemName: The name of the menu item to display.
     - Parameter iconName: The name of the image to use as the menu item icon.
     */
    func fiillTable(_ itemName: String, _ iconName: UIImage?) {
        lblName.text = itemName
        imgIcon.image = iconName
    }
    
    // MARK: - Private Methods
    /**
     Configures the UI of the cell.
     */
    private func configureUI() {
        contentView.addSubview(lblName)
        contentView.addSubview(imgIcon)
        NSLayoutConstraint.activate([
            imgIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imgIcon.widthAnchor.constraint(equalTo: imgIcon.heightAnchor),
            imgIcon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            imgIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            lblName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lblName.leadingAnchor.constraint(equalTo: imgIcon.trailingAnchor, constant: 10),
            lblName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        lblName.font = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10)/2)
    }
}
