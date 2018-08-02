//
//  SplitViewController.swift
//  HajjDoctorIos
//
//  Created by Hosam Elsafty on 8/2/18.
//  Copyright © 2018 Hosam Elsafty. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController,
UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return true
    }
}
