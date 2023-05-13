//
//  HeadProfileTblViewCell.swift
//  Industry
//
//  Created by  Даниил on 24.04.2023.
//

import UIKit

class HeadMenuTblViewCell: UITableViewCell {
    // MARK: - Properties
    /// The reuse identifier for this cell.
    static let indificatorCell = "HeadProfileTblViewCell"
    
    /// A UILabel displaying the first, last and  name of the user.
    lazy private var lblFIO: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    /// A UILabel displaying the division of the user.
    lazy private var lblDivisionUser: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    /// A UILabel displaying the role of the user.
    lazy private var lblRoleUser: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    /// A UIView container image
    private lazy var viewProfileImageContainer: UIView = {
        let imageView = UIView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// A UIImageView  image user
    private lazy var imgAvatarUser: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
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
     Fills the table view cell with the head menu user.
     - Parameter FIO: The last, first and midle name user
     - Parameter devisionUser: The devision on work user
     - Parameter role: The role user
     - Parameter nameImgAvatar: The path from image user
     */
    func fiillTable(_ FIO: String, _ devisionUser: String,_ role: String, _ nameImgAvatar: String) {
        lblFIO.text = FIO
        lblDivisionUser.text = "Подразделения: ".localized + devisionUser
        imgAvatarUser.image = UIImage(named: nameImgAvatar)
        lblRoleUser.text = "Должность: ".localized + role
    }
    
    // MARK: - Private Methods
    /**
     Configures the UI of the cell.
     */
    private func configureUI() {
        contentView.addSubview(lblFIO)
        contentView.addSubview(lblDivisionUser)
        contentView.addSubview(viewProfileImageContainer)
        contentView.addSubview(lblRoleUser)
        viewProfileImageContainer.addSubview(imgAvatarUser)
        NSLayoutConstraint.activate([
            viewProfileImageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            viewProfileImageContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            viewProfileImageContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 2.0/9.0),
            viewProfileImageContainer.heightAnchor.constraint(equalTo: viewProfileImageContainer.widthAnchor, multiplier: 1.0),
            
            imgAvatarUser.topAnchor.constraint(equalTo: viewProfileImageContainer.topAnchor),
            imgAvatarUser.leadingAnchor.constraint(equalTo: viewProfileImageContainer.leadingAnchor),
            imgAvatarUser.trailingAnchor.constraint(equalTo: viewProfileImageContainer.trailingAnchor),
            imgAvatarUser.bottomAnchor.constraint(equalTo: viewProfileImageContainer.bottomAnchor),
            
            
            lblFIO.leadingAnchor.constraint(equalTo: imgAvatarUser.trailingAnchor, constant: 10),
            lblFIO.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            lblFIO.bottomAnchor.constraint(equalTo: lblDivisionUser.topAnchor, constant: -5),
            
            lblDivisionUser.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lblDivisionUser.leadingAnchor.constraint(equalTo: imgAvatarUser.trailingAnchor, constant: 10),
            lblDivisionUser.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            lblRoleUser.topAnchor.constraint(equalTo: lblDivisionUser.bottomAnchor, constant: 5),
            lblRoleUser.leadingAnchor.constraint(equalTo: imgAvatarUser.trailingAnchor, constant: 10),
            lblRoleUser.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
        let lblSizeFont = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10)/2)
        lblFIO.font = lblSizeFont
        lblDivisionUser.font = lblSizeFont
        lblRoleUser.font = lblSizeFont
    }
}
