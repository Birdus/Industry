//
//  DocumentFlowViewController.swift
//  Industry
//
//  Created by  Даниил on 24.04.2023.
//

import UIKit

class DocumentFlowViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
}

extension DocumentFlowViewController: TabBarControllerDelegate {
    func tabBarController(_ tabBarController: TabBarController, didSelectTabAtIndex index: Int, issues datas: [Issues], employee data: Employee) {
        return
    }
}
