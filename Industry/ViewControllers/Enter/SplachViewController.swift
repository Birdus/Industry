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
        lbl.textColor = UIColor.white
        lbl.font = lbl.font.withSize(30)
        lbl.text = "Добро пожаловать!".localized
        return lbl
    }()
    
    
    // other properties and methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    private func configureUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        self.view.addSubview(lblGreeting)
        self.view.bringSubviewToFront(lblGreeting)
        lblGreeting.layer.zPosition = 1
        NSLayoutConstraint.activate([
            lblGreeting.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lblGreeting.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        animateGradient()
    }
    
    private func animateGradient() {
        let gradientLayer = CAGradientLayer()
        let colorTop = UIColor(red: 1, green: 0.498, blue: 0.247, alpha: 1).cgColor
        let colorBottom = UIColor(red: 0.839, green: 0.235, blue: 0.494, alpha: 1).cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.view.bounds
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [colorTop, colorBottom]
        animation.toValue = [colorBottom, colorTop]
        animation.duration = 1.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        self.view.layer.zPosition = -1
        gradientLayer.add(animation, forKey: nil)
        self.view.layer.addSublayer(gradientLayer)
    }
}


