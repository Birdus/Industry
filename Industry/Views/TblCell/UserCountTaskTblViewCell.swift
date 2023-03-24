//
//  UserCountTaskTblViewCell.swift
//  Industry
//
//  Created by Birdus on 19.03.2023.
//

import UIKit

class UserCountTaskTblViewCell: UITableViewCell {

    static let indificatorCell: String = "UserCountTaskTblViewCell"
    
    lazy private var lblCountTask: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy private var lblCountTaskDescribe: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.gray
        lbl.text = "Выполнено задач".localized
        return lbl
    }()
    
    lazy private var lblCountTime: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.black
        
        return lbl
    }()
    
    lazy private var lblCountTimeDescribe: UILabel = {
        var lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor.gray
        lbl.text =  "Количество часов".localized
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func fiillTable(_ countTask: Int, _ countTime: Int) {
        lblCountTask.text =  String(countTask)
        lblCountTime.text = String(countTime)
    }
    
    private func configureUI() {
        contentView.addSubview(lblCountTask)
        contentView.addSubview(lblCountTime)
        contentView.addSubview(lblCountTaskDescribe)
        contentView.addSubview(lblCountTimeDescribe)
        
        let fontScale: CGFloat = bounds.width / 10 - 10
        let subFontScale: CGFloat = bounds.width / 12 / 2
        
        NSLayoutConstraint.activate([
            lblCountTask.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
                   lblCountTask.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                   lblCountTask.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
                   lblCountTask.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.1),

                   lblCountTaskDescribe.topAnchor.constraint(equalTo: lblCountTask.bottomAnchor, constant: -10),
                   lblCountTaskDescribe.leadingAnchor.constraint(equalTo: lblCountTask.leadingAnchor),
                   lblCountTaskDescribe.widthAnchor.constraint(equalTo: lblCountTask.widthAnchor),
                   lblCountTaskDescribe.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),

                   lblCountTime.topAnchor.constraint(equalTo: lblCountTask.topAnchor),
                   lblCountTime.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -30),
                   lblCountTime.widthAnchor.constraint(equalTo: lblCountTask.widthAnchor),
                   lblCountTime.heightAnchor.constraint(equalTo: lblCountTask.heightAnchor),

                   lblCountTimeDescribe.topAnchor.constraint(equalTo: lblCountTaskDescribe.topAnchor),
                   lblCountTimeDescribe.trailingAnchor.constraint(equalTo: lblCountTime.trailingAnchor),
                   lblCountTimeDescribe.widthAnchor.constraint(equalTo: lblCountTime.widthAnchor),
                   lblCountTimeDescribe.bottomAnchor.constraint(equalTo: lblCountTaskDescribe.bottomAnchor),

                   lblCountTaskDescribe.bottomAnchor.constraint(equalTo: lblCountTimeDescribe.topAnchor, constant: -2)
        ])
        
        lblCountTask.font = UIFont.boldSystemFont(ofSize: fontScale * 1.5)
        lblCountTime.font = UIFont.boldSystemFont(ofSize: fontScale * 1.5)
        lblCountTaskDescribe.font = UIFont.systemFont(ofSize: subFontScale * 1.1)
        lblCountTimeDescribe.font = UIFont.systemFont(ofSize: subFontScale * 1.1)
    }



}
