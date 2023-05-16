//
//  SetingUserTblViewCell.swift
//  Industry
//
//  Created by  Даниил on 07.05.2023.
//

import UIKit

class SetingUserTblViewCell: UITableViewCell {
    
    static let indificatorCell = "MenuItemTblViewCell"
    
    private lazy var swhSeting: UISwitch = {
        let swh: UISwitch = UISwitch()
        swh.translatesAutoresizingMaskIntoConstraints = false
        swh.isOn = true
        swh.setOn(true, animated: true)
        swh.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        return swh
    }()
    
    private lazy var lblDescription: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = .black
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func switchValueDidChange(_ sender: UISwitch) {
        
    }
    
    func fiillTable(_ description: String, _ switchIsOn : Bool) {
        lblDescription.text = description
        swhSeting.isOn = switchIsOn
    }
    
    private func configureUI() {
        self.addSubview(lblDescription)
        self.addSubview(swhSeting)
        lblDescription.font = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10)/2)
        NSLayoutConstraint.activate([
            lblDescription.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            lblDescription.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15),
            lblDescription.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            lblDescription.trailingAnchor.constraint(equalTo: swhSeting.leadingAnchor, constant: -15),
            lblDescription.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            swhSeting.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15),
            swhSeting.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            swhSeting.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            swhSeting.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            
        ])
    }
}
