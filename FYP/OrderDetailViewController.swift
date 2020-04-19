//
//  OrderDetailViewController.swift
//  FYP
//
//  Created by PY on 11/4/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit
import SwiftyJSON
class OrderDetailViewController: UIViewController {
    
    
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerAddress: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopAddress: UILabel!
    @IBOutlet weak var productTableView: UITableView!
    var orderId: Int?
    var type: String?
    var cart = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
        
        
        // Do any additional setup after loading the view.
    }
    
    func loadDetails(){
        APIManager.shared.getSpeicificOrder(orderID: self.orderId!,type: self.type!){ (json) in
            let order = json?["order"]
            
            
            if self.type == "default"{
                self.customerName.text = order?["customer"]["name"].string
                self.customerAddress.text = order?["customer"]["address"].string
                self.customerPhone.text = order?["customer"]["phone"].string
                self.shopAddress.text = order?["shop"]["address"].string!
                self.shopName.text = order?["shop"]["name"].string!
                if order?["status"] != nil {
                    if let details = order?["order_details"].array{
                        self.cart = details
                        self.productTableView.reloadData()
                    }
                }
            } else{
                self.customerName.text = order?["customer"]["name"].string
                self.customerAddress.text = order?["customer"]["address"].string
                self.customerPhone.text = order?["customer"]["phone"].string
                self.shopAddress.text = order?["shopaddress"].string!
                self.shopName.text = order?["shopname"].string!
                if order?["status"] != nil {
                    if let details = order?["order_details"].array{
                        self.cart = details
                        self.productTableView.reloadData()
                    }
                }
            }
            
        }
    }
}
extension OrderDetailViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as! OrderTableViewCell
        
        let product = cart[indexPath.row]
        cell.quantity.text = String(product["quantity"].int!)
        cell.subTotal.text = "$\(String(product["sub_total"].float!))"
        if self.type == "default"{
            cell.name.text = product["product"]["name"].string
        } else{
            
            cell.name.text = product["productname"].string
        }
        return cell
    }
    
}

