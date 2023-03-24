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
    
    lazy private var lblDeadlLine: UILabel = {
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
        lblDeadlLine.text = deadLine
    }
    
    private func configureUI () {
        contentView.addSubview(lblTaskName)
        contentView.addSubview(lblDescription)
        contentView.addSubview(lblDeadlLine)
        NSLayoutConstraint.activate([
            lblTaskName.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            lblTaskName.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            lblTaskName.widthAnchor.constraint(equalToConstant: self.bounds.width/1.5),
            lblTaskName.rightAnchor.constraint(equalTo: lblDeadlLine.safeAreaLayoutGuide.leftAnchor, constant: 10),

            lblDeadlLine.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            lblDeadlLine.widthAnchor.constraint(equalToConstant: self.bounds.width/2),
            lblDeadlLine.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            lblDeadlLine.leftAnchor.constraint(equalTo: lblTaskName.safeAreaLayoutGuide.rightAnchor, constant: -10),

            lblDescription.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            lblDescription.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            lblDescription.topAnchor.constraint(equalTo: lblTaskName.bottomAnchor, constant: 10),
            lblDescription.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        lblTaskName.font = UIFont.systemFont(ofSize: CGFloat(self.frame.height/8))
        lblDescription.font = UIFont.systemFont(ofSize: CGFloat(self.frame.height/8))
        lblDeadlLine.font = UIFont.systemFont(ofSize: CGFloat(self.frame.height/8))
    }
}
