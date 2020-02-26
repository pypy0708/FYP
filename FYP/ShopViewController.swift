//
//  ShopViewController.swift
//  FYP
//
//  Created by yoshi on 4/2/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil{
        menuBarButton.target = self.revealViewController()
        menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    }
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    
    
    
}

extension ShopViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath)
    
    return cell
    }
}
