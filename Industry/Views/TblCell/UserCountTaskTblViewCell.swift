//
//  UserCountTaskTblViewCell.swift
//  Industry
//
//  Created by Birdus on 19.03.2023.
//

import UIKit

/**
 The cell used to display the user's completed task count and total time spent on those tasks in a table view.
 */
class UserCountTaskTblViewCell: UITableViewCell {
    
    // MARK: - Properties
    /// The reuse identifier for this cell.
    static let indificatorCell = "UserCountTaskTblViewCell"
    
    /// The label displaying the count of completed tasks.
    private lazy var lblCountTask: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = .black
        return lbl
    }()
    
    /// The label describing the count of completed tasks.
    private lazy var lblCountTaskDescribe: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = .gray
        lbl.text = "Выполнено задач".localized
        return lbl
    }()
    
    /// The label displaying the total time spent on completed tasks.
    private lazy var lblCountTime: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = .black
        return lbl
    }()
    
    
    /// The label describing the total time spent on completed tasks.
    private lazy var lblCountTimeDescribe: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = .gray
        lbl.text =  "Количество часов".localized
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
    
    // MARK: - Public Methods
    
    /**
     Fills the table view cell with the given task and time count.
     - Parameter countTask: The count of completed tasks to display.
     - Parameter countTime: The total time spent on completed tasks to display.
     */
    func fiillTable(_ countTask: Int, _ countTime: Int) {
        lblCountTask.text = String(countTask)
        lblCountTime.text = String(countTime)
    }
    
    // MARK: - Private Methods
    
    /**
     Configures the UI of the cell.
     */
    
    private func configureUI() {
        contentView.addSubview(lblCountTask)
        contentView.addSubview(lblCountTime)
        contentView.addSubview(lblCountTaskDescribe)
        contentView.addSubview(lblCountTimeDescribe)
        NSLayoutConstraint.activate([
            // lblCountTask constraints
            lblCountTask.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            lblCountTask.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            lblCountTask.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10 ),
            lblCountTask.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.1),
            
            // lblCountTaskDescribe constraints
            lblCountTaskDescribe.topAnchor.constraint(equalTo: lblCountTask.bottomAnchor, constant: -10),
            lblCountTaskDescribe.leadingAnchor.constraint(equalTo: lblCountTask.leadingAnchor),
            lblCountTaskDescribe.widthAnchor.constraint(equalTo: lblCountTask.widthAnchor),
            lblCountTaskDescribe.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            // lblCountTime constraints
            lblCountTime.topAnchor.constraint(equalTo: lblCountTask.topAnchor),
            lblCountTime.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10),
            lblCountTime.widthAnchor.constraint(equalTo: lblCountTask.widthAnchor),
            lblCountTime.heightAnchor.constraint(equalTo: lblCountTask.heightAnchor),
            
            // lblCountTimeDescribe constraints
            lblCountTimeDescribe.topAnchor.constraint(equalTo: lblCountTaskDescribe.topAnchor),
            lblCountTimeDescribe.trailingAnchor.constraint(equalTo: lblCountTime.trailingAnchor),
            lblCountTimeDescribe.widthAnchor.constraint(equalTo: lblCountTime.widthAnchor),
            lblCountTimeDescribe.bottomAnchor.constraint(equalTo: lblCountTaskDescribe.bottomAnchor),
        ])
        
        // Set font
        let fontScale = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10))
        let subFontScale = UIFont.systemFont(ofSize: CGFloat(UIScreen.main.bounds.width/10)/2)
        lblCountTask.font = fontScale
        lblCountTime.font = fontScale
        lblCountTaskDescribe.font = subFontScale
        lblCountTimeDescribe.font = subFontScale
    }
}
