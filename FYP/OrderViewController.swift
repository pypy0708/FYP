//
//  OrderViewController.swift
//  FYP
//
//  Created by yoshi on 6/2/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMaps
import GooglePlaces

class OrderViewController: UIViewController {
    
    @IBOutlet weak var productTableView: UITableView!
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var aMap: GMSMapView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    var shoplat: Double?
    var shoplng: Double?
    var customerlat: Double?
    var customerlng: Double?
    var cart = [JSON]()
    var route = GMSPolyline()
    var aroute = GMSPolyline()
    var timer = Timer()
    var deliverymanMarker = GMSMarker()
    var type: String?
    var shoplocation: String?
    var shopname: String?
    var customerlocation: String?
    var deliverymode: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        getDeliverymanLocation(self)
        getOrder()
        //self.timer.invalidate()
    }
    
    func getOrder() {
        APIManager.shared.getOrder{ (json) in
            let order = json?["order"]
            if order?["status"] != nil {
                if let details = order?["order_details"].array{
                    if order?["type"] == "default"{
                        self.type = "default"
                        self.cart = details
                        self.status.text = order?["status"].string?.uppercased()
                        self.productTableView.reloadData()
                        
                        if order?["status"].string != "Delivered" {
                            self.timerFunc()
                        }
                        print(self.cart)
                        
                        self.shoplocation = order?["shop"]["address"].string!
                        self.shopname = order?["shop"]["name"].string!
                        self.customerlocation = order?["customer"]["address"].string!
                        self.deliverymode = order?["deliveryman"]["type"].string!
                    } else{
                        self.type = "customized"
                        self.cart = details
                        self.status.text = order?["status"].string?.uppercased()
                        self.productTableView.reloadData()
                        
                        if order?["status"].string != "Delivered" {
                            self.timerFunc()
                        }
                        print(self.cart)
                        
                        self.shoplocation = order?["shopaddress"].string!
                        self.shopname = order?["shopname"].string!
                        self.customerlocation = order?["customer"]["address"].string!
                        self.deliverymode = order?["deliveryman"]["type"].string!
                    }
                    self.getLocation(self.shoplocation!, "Shop:\(self.shopname!)", { (lat,lng) in
                        self.shoplat = lat
                        self.shoplng = lng
                        
                        self.getLocation(self.customerlocation!, "You", { (lat,lng) in
                            self.customerlat = lat
                            self.customerlng = lng
                            APIManager.shared.getPath(mode: self.deliverymode!,deslat: self.customerlat!, deslng: self.customerlng!, sourcelat: self.shoplat!, sourcelng: self.shoplng!) { (polyline) in
                                let path = GMSPath(fromEncodedPath: polyline)
                                self.route.map = nil
                                self.route = GMSPolyline(path: path)
                                self.route.strokeWidth = 1
                                self.route.strokeColor = UIColor.blue
                                self.route.map = self.aMap
                                let camera = GMSCameraPosition.camera(withLatitude: lat,
                                                                      longitude: lng,
                                                                      zoom: 15)
                                self.aMap.camera = camera
                            }
                            APIManager.shared.getPath(mode: self.deliverymode!,deslat: self.shoplat!, deslng: self.shoplng!, sourcelat: self.deliverymanMarker.position.latitude, sourcelng: self.deliverymanMarker.position.longitude) { (polyline) in
                                let path = GMSPath(fromEncodedPath: polyline)
                                self.aroute.map = nil
                                self.aroute = GMSPolyline(path: path)
                                print("hi\(polyline)")
                                self.aroute.strokeWidth = 1
                                self.aroute.strokeColor = UIColor.red
                                self.aroute.map = self.aMap
                            }
                        })
                    })
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
    
    @objc func getDeliverymanLocation(_ sender: Any){
        APIManager.shared.getLocation{ (json) in
            if let coordinates = json?["location"].string{
                let separate = coordinates.components(separatedBy: ",")
                let Slat = separate[0]
                let Slng = separate[1]
                let lat = Double(Slat)
                let lng = Double(Slng)
                
                //let marker = GMSMarker()
                self.deliverymanMarker.map = nil
                self.deliverymanMarker.position.latitude=lat!
                self.deliverymanMarker.position.longitude=lng!
                self.deliverymanMarker.title = "Deliveryman"
                let image = UIImage(named: "icons8-deliver-food-40")
                self.deliverymanMarker.icon = image
                self.deliverymanMarker.map = self.aMap
                
            }
        }
    }
    
    func timerFunc() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(getDeliverymanLocation(_ :)), userInfo: nil, repeats: true)
    }
}

extension OrderViewController: UITableViewDelegate,UITableViewDataSource{
    
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
        if type == "default"{
            cell.name.text = product["product"]["name"].string
        } else{
            cell.name.text = product["productname"].string
        }
        return cell
    }
}

extension OrderViewController: GMSMapViewDelegate{
    
    
    func getLocation(_ address: String,_ title: String,_ completionHandler: @escaping (Double,Double) -> Void) {
        
        let inputaddress = address.replacingOccurrences(of: " ", with: "%20")
        
        
        APIManager.shared.getCoordinates(inputaddress: inputaddress) { (lat, lng) in
            
            let marker = GMSMarker()
            marker.position.latitude=lat
            marker.position.longitude=lng
            marker.title = title
            marker.map = self.aMap
            if title == "You" {
                let image = UIImage(named: "icons8-customer-40")
                marker.icon = image
            } else {
                let image = UIImage(named: "icons8-shop-40")
                marker.icon = image
            }
            completionHandler(lat,lng)
            
            
        }
    }
    
}
