//
//  ViewController.swift
//  Industry
//
//  Created by birdus on 24.02.2023.
//
/**
 A custom SplachViewController used for the Industry app's menu bar.

 - Author: Daniil
 - Version: 1.0
 */
import UIKit

// MARK: - SplachViewController

class SplachViewController: UIViewController {

    // MARK: - Properties
    /// Text welcome application.
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
    /// Configures the UI elements of the view controller.
    private func configureUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        self.view.addSubview(lblGreeting)
        NSLayoutConstraint.activate([
            lblGreeting.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lblGreeting.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

