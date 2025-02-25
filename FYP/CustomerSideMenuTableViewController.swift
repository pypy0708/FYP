//
//  CustomerSideMenuTableViewController.swift
//  FYP
//
//  Created by yoshi on 4/2/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class CustomerSideMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // User.currentUser.refresh()
        username.text = User.currentUser.name
        avatar.image = try! UIImage(data: Data(contentsOf: URL(string: User.currentUser.pictureURL!)!))
        avatar.layer.cornerRadius = 70 / 2
        avatar.layer.borderWidth = 1.0
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.clipsToBounds = true
        view.backgroundColor = UIColor(red: 1, green: 247/255, blue: 185/255, alpha: 1.0)
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "CustomerLogout"{
            APIManager.shared.logout(completionHandler: { (error )in
                if error == nil {
                    FBManager.shared.logOut()
                    User.currentUser.resetInfo()
                    
                    //logout => re-render the loginview
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let appController = storyboard.instantiateViewController(withIdentifier: "MainController") as! LoginViewController
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController = appController
                }
            })
            return false
        }
        return true
    }
    
    
}
