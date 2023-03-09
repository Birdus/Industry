//
//  TaskListViewController.swift
//  Industry
//
//  Created by Даниил on 09.03.2023.
//

import UIKit

class TaskListViewController: UIViewController {
    
    lazy private var tblTask: UITableView = {
        let tbl = UITableView()
        tbl.register(TaskListTblViewCell.self, forCellReuseIdentifier: TaskListTblViewCell.indificatorCell)
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.dataSource = self
        tbl.delegate = self
        tbl.backgroundColor = .clear
        tbl.separatorStyle = .singleLine
        tbl.separatorColor = .white
        tbl.separatorEffect = .none
        tbl.separatorInset = .zero
        tbl.separatorInsetReference = .fromCellEdges
        tbl.allowsSelectionDuringEditing = false
        tbl.layer.masksToBounds = true
        tbl.layer.shadowColor = UIColor.darkGray.cgColor;
        tbl.layer.shadowOffset = CGSize(width: 1.0, height: 1.0);
        tbl.layer.shadowOpacity = 0.4;
        tbl.layer.shadowRadius = 5.0;
        tbl.clipsToBounds = false;
        tbl.layer.masksToBounds = false;
        tbl.layer.cornerRadius = 10
        tbl.backgroundColor = .white
        tbl.layer.masksToBounds = true
        tbl.layer.borderColor = UIColor( red: 153/255, green: 153/255, blue:0/255, alpha: 1.0 ).cgColor
        tbl.layer.borderWidth = 2.0
        tbl.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        return tbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(tblTask)
        NSLayoutConstraint.activate([
            tblTask.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tblTask.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tblTask.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tblTask.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            
        ])
        tblTask.rowHeight = ((UIScreen.main.bounds.size.height/2 + tblTask.contentOffset.y) / 3 )
    }
    
}

extension TaskListViewController: UITableViewDelegate {
    
    
    
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblTask.dequeueReusableCell(withIdentifier: TaskListTblViewCell.indificatorCell, for: indexPath) as?
                TaskListTblViewCell else {
            return UITableViewCell()
        }
//        cell.selectionStyle = .none
//        cell.contentView.backgroundColor = .clear
//        cell.backgroundColor = UIColor(red: 79.0/100, green: 4.0/100, blue: 66.0/100, alpha: 1)
        
        cell.fillTable("Сделать диплом", "02.03.2023", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam viverra interdum tortor. Quisque mollis odio ut tellus dictum hendrerit. Nunc ut est odio. Nulla rhoncus aliquet suscipit. Vivamus a finibus nisi. Cras et imperdiet ipsum. Morbi auctor dui ut gravida.")
        return cell
    }
    
   
}
