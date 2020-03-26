//
//  DeliveryOrdersTableViewController.swift
//  FYP
//
//  Created by yoshi on 6/2/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class DeliveryOrdersTableViewController: UITableViewController {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    var orders = [DeliverymanOrder]()
    let loading  = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadOrders()
    }
    func loadOrders() {
        Tools.showLoading(loading, self.view)
        APIManager.shared.deliveryManGetOrder{ (json) in
            if json != nil{
                self.orders = []
                if let assignOrder = json!["orders"].array{
                    for item in assignOrder{
                        let order = DeliverymanOrder(json: item)
                        self.orders.append(order)                     
                    }
                }
                self.tableView.reloadData()
                Tools.stopLoading(self.loading)
            }
        }
    }
    
    private func acceptOrder(orderId: Int) {
        APIManager.shared.acceptOrder(orderId: orderId) { (json) in
            if let status = json!["status"].string {
                
                switch status {
                case "fail":
                    let alert = UIAlertController(title: "Error", message: json!["error"].string!, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                default:
                    let alert = UIAlertController(title: nil, message: "Success!", preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "Show my map", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "CurrentOrder", sender: self)
                    })
                    alert.addAction(confirmAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliverymanOrderCell", for: indexPath) as! DeliverymanOrderTableViewCell
        
        let order = orders[indexPath.row]
        cell.customerName.text = order.customerName
        cell.orderAddress.text = order.orderAddress
        cell.shopName.text = order.shopName
        cell.customerIcon.image = try! UIImage(data: Data(contentsOf: URL(string: order.customerIcon!)!))
        cell.customerIcon.layer.cornerRadius = 50/2
        cell.customerIcon.clipsToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = orders[indexPath.row]
        self.acceptOrder(orderId: order.id!)
    }
}
