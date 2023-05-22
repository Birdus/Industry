//
//  NewTaskViewController.swift
//  Industry
//
//  Created by  Даниил on 22.05.2023.
//

import UIKit

class NewTaskViewController: UIViewController {
    // MARK: - Private UI
    private lazy var tblNewTask: UITableView = {
        let tableView = UITableView()
        tableView.register(SetingUserTblViewCell.self, forCellReuseIdentifier: SetingUserTblViewCell.indificatorCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private func
    private func configureUI() {
        self.view.addSubview(tblNewTask)
        NSLayoutConstraint.activate([
            tblNewTask.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tblNewTask.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tblNewTask.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tblNewTask.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 5)
        ])
    }
}

// MARK: - UITableViewDataSource
extension NewTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension NewTaskViewController: UITableViewDelegate {
    
}
