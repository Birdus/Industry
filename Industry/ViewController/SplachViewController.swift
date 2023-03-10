//
//  ViewController.swift
//  Industry
//
//  Created by birdus on 24.02.2023.
//

import UIKit

class SplachViewController: UIViewController {

    // MARK: - Privates Ui
    private lazy var lblGreeting: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = UIColor.black
        lbl.font = lbl.font.withSize(30)
        lbl.text = "Добро пожаловать!".localized
        return lbl
    }()
    
    // MARK: - Application lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Privates func
    
    private func configureUI() {
        view.backgroundColor = .white
        self.view.addSubview(lblGreeting)
        NSLayoutConstraint.activate([
            lblGreeting.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lblGreeting.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

