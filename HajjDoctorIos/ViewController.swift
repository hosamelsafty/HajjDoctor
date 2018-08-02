//
//  ViewController.swift
//  HajjDoctorIos
//
//  Created by Hosam Elsafty on 8/1/18.
//  Copyright © 2018 Hosam Elsafty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!{
        didSet{
            logo.image = UIImage(named: "AppIcon")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

