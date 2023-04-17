//
//  TaskListCollectionViewCell.swift
//  Industry
//
//  Created by Даниил on 09.03.2023.
//

import UIKit

class TaskCollViewCell: UICollectionViewCell {
    
    static let indificatorCell: String = "TaskListTblViewCell"
    
    lazy private var lblTaskName: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy private var lblDeadline: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .right
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy private var lblDescription: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 3
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 2
        return lbl
    }()
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            configureUI ()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func fillTable(_ taskName: String, _ deadLine: String ,_ taskDiscription: String) {
        lblTaskName.text = taskName
        lblDescription.text = taskDiscription
        lblDeadline.text = deadLine
    }
    
    private func configureUI () {
        contentView.addSubview(lblTaskName)
           contentView.addSubview(lblDescription)
           contentView.addSubview(lblDeadline)
           
           let margin: CGFloat = 10
           let heightRatio: CGFloat = 8
           
           NSLayoutConstraint.activate([
               lblTaskName.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: margin),
               lblTaskName.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: margin),
               lblTaskName.widthAnchor.constraint(equalToConstant: self.bounds.width / 1.5),
               lblTaskName.trailingAnchor.constraint(equalTo: lblDeadline.safeAreaLayoutGuide.leadingAnchor, constant: -margin),
               
               lblDeadline.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -margin),
               lblDeadline.widthAnchor.constraint(equalToConstant: self.bounds.width / 2),
               lblDeadline.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: margin),
               lblDeadline.leadingAnchor.constraint(equalTo: lblTaskName.safeAreaLayoutGuide.trailingAnchor, constant: margin),
               
               lblDescription.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: margin),
               lblDescription.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -margin),
               lblDescription.topAnchor.constraint(equalTo: lblTaskName.bottomAnchor, constant: margin),
            lblDescription.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        lblTaskName.font = UIFont.systemFont(ofSize: CGFloat(self.frame.height/8))
        lblDescription.font = UIFont.systemFont(ofSize: CGFloat(self.frame.height/8))
        lblDeadline.font = UIFont.systemFont(ofSize: CGFloat(self.frame.height/8))
    }
}
