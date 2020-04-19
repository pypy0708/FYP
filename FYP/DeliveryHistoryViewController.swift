//
//  DeliveryHistoryViewController.swift
//  FYP
//
//  Created by yoshi on 12/4/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class DeliveryHistoryViewController: UIViewController {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var type: UIPickerView!
    @IBOutlet weak var orderHistoryTableView: UITableView!
    var orders = [Order]()
    var types = [String]()
    var index: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.type.delegate = self
        //        self.type.dataSource = self
        types = ["default","customized"]
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        loadOrders()
    }
    let loading  = UIActivityIndicatorView()
    
    func loadOrders (){
        Tools.showLoading(loading,view)
        index = type.selectedRow(inComponent: 0)
        APIManager.shared.deliverymanGetHistoryOrders(type: types[index!]){ (json) in
            if json != nil{
                self.orders = []
                
                if let orderlist = json!["orders"].array{
                    for item in orderlist{
                        let order = Order(json: item,type: self.types[self.index!])
                        self.orders.append(order)
                    }
                    self.orderHistoryTableView.reloadData()
                    Tools.stopLoading(self.loading)
                }
            }
        }
    }
    
}

extension DeliveryHistoryViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        loadOrders()
        return types[row]
    }
    
    func selectedRow(inComponent component: Int) -> Int{
        return component
    }
}


extension DeliveryHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryHistoryCell", for: indexPath) as! DeliveryHistoryTableViewCell
        
        let order = orders[indexPath.row]
        
        cell.customerName.text = order.customerName!
        cell.customerAddress.text = order.customerAddress!
        cell.shopName.text = order.shopName!
        cell.shopAddress.text = order.shopAddress!
        cell.total.text = "$\(order.total!)"
        var tempdate = order.date?.replacingOccurrences(of: "T", with: " ")
        tempdate = tempdate?.replacingOccurrences(of: "Z", with: "")
        cell.date.text = tempdate
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderDetail"{
            let controller = segue.destination as! OrderDetailViewController
            controller.orderId = orders[(orderHistoryTableView.indexPathForSelectedRow?.row)!].id
            controller.type = orders[(orderHistoryTableView.indexPathForSelectedRow?.row)!].type
        }
    }
}
