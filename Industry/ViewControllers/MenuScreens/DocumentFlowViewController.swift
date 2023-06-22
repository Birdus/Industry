//
//  DocumentFlowViewController.swift
//  Industry
//
//  Created by  Даниил on 24.04.2023.
//

import UIKit

/// `DocumentFlowViewController` is a `UIViewController` that manages document flow.
/// - Todo: Implement WebSocket connection for real-time updates.
class DocumentFlowViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    deinit {
        print("sucsses closed DocumentFlowViewController")
    }
}

extension DocumentFlowViewController: TabBarControllerDelegate {
    /// This method is called when a tab is selected in the `TabBarController`.
    /// - Parameters:
    ///   - tabBarController: The `TabBarController` where the tab was selected.
    ///   - index: The index of the selected tab.
    ///   - datas: An array of `Issues` objects.
    ///   - data: An `Employee` object.
    func tabBarController(_ tabBarController: TabBarController, didSelectTabAtIndex index: Int, issues datas: [Issues], employee data: Employee) {
        return
    }
}
