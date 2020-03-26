//
//  DeliveryStatisticViewController.swift
//  FYP
//
//  Created by yoshi on 22/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class DeliveryStatisticViewController: UIViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    

    

}
