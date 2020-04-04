//
//  testingViewController.swift
//  FYP
//
//  Created by yoshi on 28/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit
import SwiftyJSON
import Stripe
import GoogleMaps
import GooglePlaces
import CoreLocation

class CustomizedOrderViewController: UIViewController {
    
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var tbv: UITableView!
    @IBOutlet weak var customerAddress: UITextField!
    @IBOutlet weak var shopAddress: UITextField!
    @IBOutlet weak var shopName: UITextField!
    @IBOutlet weak var customerPhone: UITextField!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var aMap: GMSMapView!
    var locationManager: CLLocationManager!
    var placesClient: GMSPlacesClient!
    var shopmarker = GMSMarker()
    var customermarker = GMSMarker()
    var item = [JSON]()
    var productNames = [String]()
    var prices = [String]()
    var quantities = [String]()
    
    @IBOutlet weak var payment: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            placesClient = GMSPlacesClient.shared()
        }
    }
    
    
    @IBAction func insert(_ sender: Any) {
        if (productName.text != "") && (price.text != "") && (quantity.text != ""){
        productNames.append(productName.text!)
        prices.append(price.text!)
        quantities.append(quantity.text!)
        let aquantity = Int(quantity.text!)
        let aprice = Float(price.text!)
        let customizedItem = customizedCartItem(productName: productName.text!, quantity: aquantity!, price: aprice!)
        customizedCart.currentCustomizedCart.customizedCartItems.append(customizedItem)
        self.tbv.reloadData()
        } else {
            let alert = UIAlertController(title: "Not enough info", message: "Please provide product name, maximum price and quantity.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    @IBAction func create(_ sender: Any) {
        if (customerAddress.text != "") && (customerPhone.text != "") && (shopName.text != "") && (shopAddress.text != "") && productNames.count > 0 {
        customizedCart.currentCustomizedCart.customerAddress = customerAddress.text
        customizedCart.currentCustomizedCart.shopName = shopName.text
        customizedCart.currentCustomizedCart.shopAddress = shopAddress.text
        customizedCart.currentCustomizedCart.customerPhone = customerPhone.text
        
        self.performSegue(withIdentifier: "diffpayment", sender: self)
        } else {
            let alert = UIAlertController(title: "Not enough info", message: "Please input all the infomation and order at least one product.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "diffpayment"{
            let controller = segue.destination as! PaymentViewController
            controller.type = "customize"
        }
    }
}


extension CustomizedOrderViewController: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productNames.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomizedProductCell", for: indexPath) as! CustomizedOrderTableViewCell
        
        let cart = customizedCart.currentCustomizedCart.customizedCartItems[indexPath.row]
        cell.productLabel?.text = "\(cart.productName)"
        cell.priceLabel?.text = "\(cart.price)"
        cell.quantityLabel?.text = "\(cart.quantity)"
        cell.subtotalLabel?.text = "$\(cart.price * Float(cart.quantity))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.productNames.remove(at: indexPath.row)
            self.prices.remove(at: indexPath.row)
            self.quantities.remove(at: indexPath.row)
            tbv.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension CustomizedOrderViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let tempinputaddress = textField.text
        let inputaddress = tempinputaddress?.replacingOccurrences(of: " ", with: "%20")
        
        APIManager.shared.getCoordinates(inputaddress: inputaddress!) { (lat, lng) in
            let camera = GMSCameraPosition.camera(withLatitude: lat,
                                                  longitude: lng,
                                                  zoom: 16)
            // self.aMap.setRegion(region, animated: true)
            self.aMap.camera = camera
            self.locationManager.stopUpdatingLocation()
            if textField == self.customerAddress{
                self.customermarker.map = nil
                self.customermarker.title = "You"
                self.customermarker.position.latitude=lat
                self.customermarker.position.longitude=lng
                self.customermarker.map = self.aMap
            }else {
                self.shopmarker.title = "customer"
                self.shopmarker.map = nil
                self.shopmarker.position.latitude=lat
                self.shopmarker.position.longitude=lng
                self.shopmarker.map = self.aMap
            }
            
        }
        
        
        return true
    }
}


extension CustomizedOrderViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: 16)
        self.aMap.camera = camera
        aMap.isMyLocationEnabled = true
        aMap.settings.myLocationButton = true
        
    }
}
