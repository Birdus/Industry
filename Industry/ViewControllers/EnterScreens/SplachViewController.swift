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

class SplachViewController: UIViewController {
    
    // MARK: - Private UI
    /// Text welcome application.
    private lazy var lblGreeting: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        lbl.font = lbl.font.withSize(30)
        lbl.text = "Добро пожаловать!".localized
        lbl.accessibilityIdentifier = "lblGreeting"
        return lbl
    }()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    deinit {
        print("sucsses closed SplachViewController")
    }
    
    // MARK: - Privates func
    /// Configures the UI elements of the view controller.
    private func configureUI() {
        view.backgroundColor = .white
        self.view.addSubview(lblGreeting)
        self.view.bringSubviewToFront(lblGreeting)
        self.navigationController?.isNavigationBarHidden = true
        lblGreeting.layer.zPosition = 1
        NSLayoutConstraint.activate([
            lblGreeting.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lblGreeting.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        animateGradient()
    }
    
    /// Backfraund animated in load splash view.
    private func animateGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        let startColor = UIColor(red: 0.157, green: 0.535, blue: 0.821, alpha: 1).cgColor
        let endColor = UIColor(red: 0.925, green: 0.949, blue: 0.976, alpha: 1).cgColor
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.type = .radial
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0, 0]
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [startColor, endColor]
        animation.toValue = [endColor, startColor]
        animation.duration = 2.8
        animation.autoreverses = true
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: nil)
        view.layer.addSublayer(gradientLayer)
    }
}


