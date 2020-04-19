//
//  DeliveryDeliveryViewController.swift
//  FYP
//
//  Created by yoshi on 22/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import SwiftyJSON
class DeliveryDeliveryViewController: UIViewController {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerAddress: UILabel!
    @IBOutlet weak var customerIcon: UIImageView!
    @IBOutlet weak var info: UIView!
    @IBOutlet weak var aMap: GMSMapView!
    @IBOutlet weak var complete: UIButton!
    var locationManager: CLLocationManager!
    var orderId: Int?
    var type: String?
    var shopname: String?
    var shopaddress: String?
    var shoplat: Double?
    var shoplng: Double?
    var customeraddress: String?
    var customerlat: Double?
    var customerlng: Double?
    var deliverylat: Double?
    var deliverylng: Double?
    var deliverymode: String?
    var SCroute = GMSPolyline()
    var DSroute = GMSPolyline()
    var placesClient: GMSPlacesClient!
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            //            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateLocation(_ :)), userInfo: nil, repeats: true)
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        loadInfo()
    }
    
    func loadInfo() {
        APIManager.shared.deliverymanGetOrderDetails{ (json) in
            let order = json?["order"]
            if let id = order?["id"].int, order?["status"] == "On the way" || order?["status"] == "Pickingup"{
                if order?["type"] == "default"{
                    self.type = "default"
                    self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateLocation(_ :)), userInfo: nil, repeats: true)
                    self.orderId = id
                    self.customerName.text = order?["customer"]["name"].string
                    self.customerAddress.text = order?["customer"]["address"].string
                    self.customerIcon.image = try! UIImage(data: Data(contentsOf: URL(string: (order?["customer"]["avatar"].string!)!)!))
                    self.customerIcon.layer.cornerRadius = 50/2
                    self.customerIcon.clipsToBounds = true
                    self.shopaddress = order?["shop"]["address"].string!
                    self.shopname = order?["shop"]["name"].string!
                    self.customeraddress = order?["customer"]["address"].string!
                    self.deliverymode = order?["deliveryman"]["type"].string!
                } else{
                    self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateLocation(_ :)), userInfo: nil, repeats: true)
                    self.type = "customized"
                    self.orderId = id
                    self.customerName.text = order?["customer"]["name"].string
                    self.customerAddress.text = order?["customer"]["address"].string
                    self.customerIcon.image = try! UIImage(data: Data(contentsOf: URL(string: (order?["customer"]["avatar"].string!)!)!))
                    self.customerIcon.layer.cornerRadius = 50/2
                    self.customerIcon.clipsToBounds = true
                    self.shopaddress = order?["shopaddress"].string!
                    self.shopname = order?["shopname"].string!
                    self.customeraddress = order?["customer"]["address"].string!
                    self.deliverymode = order?["deliveryman"]["type"].string!
                }
                
                self.getLocation(self.shopaddress!, "Shop:\(self.shopname!)", { (lat,lng) in
                    self.shoplat = lat
                    self.shoplng = lng
                    
                    self.getLocation(self.customeraddress!, "Customer", { (lat,lng) in
                        self.customerlat = lat
                        self.customerlng = lng
                        APIManager.shared.getPath(mode: self.deliverymode!,deslat: self.customerlat!, deslng: self.customerlng!, sourcelat: self.shoplat!, sourcelng: self.shoplng!) { (polyline) in
                            let path = GMSPath(fromEncodedPath: polyline)
                            //self.route.map = nil
                            self.SCroute = GMSPolyline(path: path)
                            self.SCroute.strokeWidth = 1
                            self.SCroute.strokeColor = UIColor.blue
                            self.SCroute.map = self.aMap
                            let camera = GMSCameraPosition.camera(withLatitude: lat,
                                                                  longitude: lng,
                                                                  zoom: 15)
                            self.aMap.camera = camera
                            self.aMap.isMyLocationEnabled = true
                            self.aMap.settings.myLocationButton = true
                            if CLLocationManager.locationServicesEnabled(){
                                self.locationManager = CLLocationManager()
                                self.locationManager.delegate = self
                                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                                self.locationManager.requestAlwaysAuthorization()
                                self.locationManager.startUpdatingLocation()
                                
                                self.placesClient = GMSPlacesClient.shared()
                            }
                        }
                        
                    })
                })
            } else{
                self.aMap.isHidden = true
                self.info.isHidden = true
                self.complete.isHidden = true
                let message = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
                message.text = "You do not have any order now."
                message.center = self.view.center
                message.textAlignment = NSTextAlignment.center
                
                
                self.view.addSubview(message)
                
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
    
    @IBAction func pickupOrder(_ sender: Any) {
        APIManager.shared.pickupOrder(type: self.type!,orderId: self.orderId!, completionHandler: { (json) in
            
        })
    }
    
    @IBAction func completeOrder(_ sender: Any) {
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (action) in
            APIManager.shared.completerOrder(type: self.type!,orderId: self.orderId!, completionHandler: { (json) in
                if json != nil{
                    self.timer.invalidate()
                    self.locationManager.stopUpdatingLocation()
                    self.performSegue(withIdentifier: "backToOrder", sender: self)
                }
            })
        }
        let alert = UIAlertController(title: "Complete Order", message: "Are you sure to complete the order?", preferredStyle: .alert)
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func updateLocation(_ sender: Any) {
        APIManager.shared.updateLocation(lat: deliverylat!, lng: deliverylng!) { (json) in
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewdetails"{
            let controller = segue.destination as! DeliverymanOrderDetailViewController
            controller.type = type
            controller.orderId = orderId
        }
    }
    
}

extension DeliveryDeliveryViewController: GMSMapViewDelegate{
    
    
    func getLocation(_ address: String,_ title: String,_ completionHandler: @escaping (Double,Double) -> Void) {
        
        let inputaddress = address.replacingOccurrences(of: " ", with: "%20")
        
        
        APIManager.shared.getCoordinates(inputaddress: inputaddress) { (lat, lng) in
            
            let marker = GMSMarker()
            marker.position.latitude=lat
            marker.position.longitude=lng
            marker.title = title
            marker.map = self.aMap
            if title == "Customer" {
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

extension DeliveryDeliveryViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        self.deliverylat = location.coordinate.latitude
        self.deliverylng = location.coordinate.longitude
        APIManager.shared.getPath(mode: self.deliverymode!,deslat: self.shoplat!, deslng: self.shoplng!, sourcelat: self.deliverylat!, sourcelng: self.deliverylng!) { (polyline) in
            let path = GMSPath(fromEncodedPath: polyline)
            //self.route.map = nil
            self.DSroute.map = nil
            self.DSroute = GMSPolyline(path: path)
            self.DSroute.strokeWidth = 1
            self.DSroute.strokeColor = UIColor.red
            self.DSroute.map = self.aMap
            //            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateLocation(_ :)), userInfo: nil, repeats: true)
        }
    }
}
