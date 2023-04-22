//
//  TaskListCollectionViewCell.swift
//  Industry
//
//  Created by Даниил on 09.03.2023.
//

import UIKit

class NotificationUserViewCell: UICollectionViewCell {
    
    static let indificatorCell: String = "NotificationUserViewCell"
    
    lazy private var iconNotification: UIImageView = {
        let icon = UIImageView()
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    lazy private var lblHeadNotification: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy private var lblDiscription: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI ()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func fillTable(_ iconNotification: UIImage?,_ taskName: String, _ deadLine: String ,_ taskDiscription: String) {
        lblHeadNotification.text = taskName
        lblDiscription.text = deadLine
        self.iconNotification.image = iconNotification
        
    }
    
    private func configureUI () {
        
        contentView.addSubview(lblHeadNotification)
        contentView.addSubview(lblDiscription)
        contentView.addSubview(iconNotification)
        NSLayoutConstraint.activate([
            // Constraint для lblHeadNotification
            lblHeadNotification.leadingAnchor.constraint(equalTo: iconNotification.trailingAnchor, constant: 10),
            lblHeadNotification.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            
            // Constraint для lblDiscription
            
            lblDiscription.leadingAnchor.constraint(equalTo: iconNotification.trailingAnchor, constant: 10),
            lblDiscription.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            lblDiscription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            lblDiscription.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            // Constraint для iconNotification
            iconNotification.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            iconNotification.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Дополнительный constraint для правильного соотношения ширины и высоты картинки
            iconNotification.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2.0/9.0),
            iconNotification.heightAnchor.constraint(equalTo: iconNotification.widthAnchor, multiplier: 1.0)
        ])
        
        
        lblHeadNotification.font = UIFont.systemFont(ofSize: CGFloat(self.frame.height/8))
        lblDiscription.font = UIFont.systemFont(ofSize: CGFloat(self.frame.height/8))
        
    }
}
