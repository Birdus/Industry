//
//  ListCaledarTblViewCell.swift
//  Industry
//
//  Created by  Даниил on 13.05.2023.
//

import UIKit

class ListCaledarTblViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let indificatorCell = "ListCaledarTblViewCell"
    
    // MARK: - Private UI
    private lazy var lblTypeAction: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = .white
        return lbl
    }()
    
    private lazy var lblDescriptionAction: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = .white
        return lbl
    }()
    
    private lazy var lblDeadLineAction: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .right
        lbl.textColor = .white
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
    
    // MARK: - Public func
    func fiillTable(_ typeAction: String, _ descriptinAction: String, _ deadLineAction: Date?) {
        if let date = deadLineAction {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM"
            lblDeadLineAction.text = dateFormatter.string(from: date)
        }
        lblTypeAction.text = typeAction
        lblDescriptionAction.text = descriptinAction
    }
    
    // MARK: - Private func
    private func configureUI() {
        self.addSubview(lblDescriptionAction)
        self.addSubview(lblTypeAction)
        self.addSubview(lblDeadLineAction)
        NSLayoutConstraint.activate([
            lblTypeAction.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            lblTypeAction.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            lblTypeAction.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            lblTypeAction.heightAnchor.constraint(equalTo: lblTypeAction.widthAnchor, multiplier: 0.1),
            
            
            lblDeadLineAction.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            lblDeadLineAction.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            lblDeadLineAction.leadingAnchor.constraint(equalTo: lblTypeAction.trailingAnchor, constant: 5),
            
            
            lblDescriptionAction.topAnchor.constraint(equalTo: lblTypeAction.bottomAnchor, constant: 5),
            lblDescriptionAction.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            lblDescriptionAction.leadingAnchor.constraint(equalTo: lblTypeAction.leadingAnchor),
            lblDescriptionAction.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])

        lblTypeAction.font = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10)/1.8)
        lblDeadLineAction.font = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10)/2.3)
        lblDescriptionAction.font = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10)/2.5)
    }

}
