//
//  TaskListCollectionViewCell.swift
//  Industry
//
//  Created by Даниил on 09.03.2023.
//

// MARK: - NotificationUserViewCell

import UIKit

/// A cell used to display notifications for a user
class NotificationUserViewCell: UICollectionViewCell {
    
    // MARK: Properties
    /// The identifier for the cell
    static let indificatorCell: String = "NotificationUserViewCell"
    
    /// An image view to display an icon for the notification
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// A label to display the title of the notification
    private lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: CGFloat(self.frame.height/8))
        return label
    }()
    
    /// A label to display the description of the notification
    private lazy var lblDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: CGFloat(self.frame.height/8))
        return label
    }()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods
    /// Fills the table with data for a notification
    /// - Parameters:
    ///   - iconImage: The image for the notification icon
    ///   - title: The title of the notification
    ///   - deadline: The deadline for the notification
    ///   - description: The description of the notification
    public func fillTable(iconImage: UIImage?, title: String, deadline: String, description: String) {
        iconImageView.image = iconImage
        lblTitle.text = title
        lblDescription.text = "\(deadline)\n\(description)"
    }
    
    // MARK: Private methods
    /// Configures the user interface for the cell
    private func configureUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblDescription)
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 2.0/9.0),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor, multiplier: 1.0),
            
            lblTitle.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            lblTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            lblTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            lblDescription.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            lblDescription.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 5),
            lblDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            lblDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
