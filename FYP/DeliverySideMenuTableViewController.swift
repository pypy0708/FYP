//
//  DeliverySideMenuTableViewController.swift
//  FYP
//
//  Created by yoshi on 6/2/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class DeliverySideMenuTableViewController: UITableViewController {


    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        username.text = User.currentUser.name
        avatar.image = try! UIImage(data: Data(contentsOf: URL(string: User.currentUser.pictureURL!)!))
        avatar.layer.cornerRadius = 70 / 2
        avatar.layer.borderWidth = 1.0
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.clipsToBounds = true
        view.backgroundColor = UIColor(red: 1, green: 247/255, blue: 185/255, alpha: 1.0)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


}
