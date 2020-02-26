//
//  ProductListTableViewController.swift
//  FYP
//
//  Created by yoshi on 5/2/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class ProductListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
            
            return cell
        }
    
}
