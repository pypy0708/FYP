//
//  DeliveryOrderViewController.swift
//  FYP
//
//  Created by yoshi on 27/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
class DeliveryOrderViewController: UIViewController {
    
    
    @IBOutlet weak var deliverymode: UISegmentedControl!
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    var orders = [DeliverymanOrder]()
    let loading  = UIActivityIndicatorView()
    @IBOutlet weak var status: UILabel!
    var locationManager: CLLocationManager!
    var deliverylat: Double?
    var deliverylng: Double?
    var placesClient: GMSPlacesClient!
    @IBOutlet weak var statusSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            placesClient = GMSPlacesClient.shared()
        }
        
        APIManager.shared.getStatus() { (json) in
            if json?["status"] == 0{
                self.status.text = "Available"
                self.statusSwitch.setOn(true, animated: true)
            }
            if json?["status"] == 1{
                self.status.text = "Delivering"
            }
            if json?["status"] == 2{
                self.status.text = "Offline"
                self.statusSwitch.setOn(false, animated: true)
            }
        }
        
        APIManager.shared.getMode() { (json) in
            let index = json?["mode"].int
            self.deliverymode.selectedSegmentIndex = index!
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
                if let assignOrder = json!["defaultorders"].array{
                    for item in assignOrder{
                        let order = DeliverymanOrder(json: item,type: "default")
                        self.orders.append(order)
                    }
                }
                if let assignOrder = json!["customizedorders"].array{
                    for item in assignOrder{
                        let order = DeliverymanOrder(json: item,type: "customized")
                        self.orders.append(order)
                    }
                }
                self.orderTableView.reloadData()
                Tools.stopLoading(self.loading)
            }
        }
    }
    
    private func acceptOrder(orderId: Int,type: String) {
        APIManager.shared.acceptOrder(orderId: orderId,type: type) { (json) in
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
    
    @IBAction func updateLocation(_ sender: Any) {
        APIManager.shared.updateLocation(lat: deliverylat!, lng: deliverylng!) { (json) in
        }
    }
    
    @IBAction func changeStatus(_ sender: Any) {
        APIManager.shared.updateStatus() { (json) in
            if json?["status"] == "failed"{
                let alert = UIAlertController(title: "Error", message: json!["error"].string!, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                if self.statusSwitch.isOn{
                    self.statusSwitch.setOn(false, animated: true)
                }else{
                    self.statusSwitch.setOn(true, animated: true)
                }
            }
            
        }
    }
    
    @IBAction func switchDeliveryMode(_ sender: Any) {

            APIManager.shared.updateMode(){(json) in}

    }
}

extension DeliveryOrderViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = orders[indexPath.row]
        self.acceptOrder(orderId: order.id!,type: order.type!)
    }
}

extension DeliveryOrderViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        self.deliverylat = location.coordinate.latitude
        self.deliverylng = location.coordinate.longitude
        }
    }

