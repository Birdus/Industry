//
//  ListEmployeesTblViewCell.swift
//  Industry
//
//  Created by  Даниил on 25.05.2023.
//

import UIKit

protocol ListEmployeesTblViewCellDelegete: AnyObject {
    func listEmployeesTblViewCell(_ cell: ListEmployeesTblViewCell, didSelected employeeId: Int, isEnclude task: Bool)
}


class ListEmployeesTblViewCell: UITableViewCell {
    // MARK: - Properties
    static let indificatorCell = "ListEmployeesTblViewCell"
    private var idEmployee: Int!
    weak var delegete: ListEmployeesTblViewCellDelegete!
    
    // MARK: - Private UI
    /// A UIView container image
    private lazy var lblEmployee: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont(name: "San Francisco", size: CGFloat(UIScreen.main.bounds.width/10)/2)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private lazy var swhEmployee: UISwitch = {
        let swh: UISwitch = UISwitch()
        swh.translatesAutoresizingMaskIntoConstraints = false
        swh.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        return swh
    }()
    
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func switchValueDidChange(_ sender: UISwitch) {
        delegete.listEmployeesTblViewCell(self, didSelected: idEmployee, isEnclude: sender.isOn)
    }
    // MARK: - Public func
    public func fillTable(employee fullName: String,employee id: Int, isInclude: Bool) {
        idEmployee = id
        lblEmployee.text = fullName
        swhEmployee.isOn = isInclude
    }
    
    // MARK: - Private func
    private func configureUI() {
        contentView.addSubview(lblEmployee)
        contentView.addSubview(swhEmployee)
        
        NSLayoutConstraint.activate([
            lblEmployee.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            lblEmployee.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            lblEmployee.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            
            swhEmployee.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            swhEmployee.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            swhEmployee.leadingAnchor.constraint(equalTo: lblEmployee.trailingAnchor, constant: 10),
            
        ])
    }


}
