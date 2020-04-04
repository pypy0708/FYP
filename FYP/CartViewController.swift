//
//  CartViewController.swift
//  FYP
//
//  Created by yoshi on 5/2/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import CoreLocation
import GooglePlaces
class CartViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var address: UIView!
    @IBOutlet weak var products: UITableView!
    @IBOutlet weak var map: UIView!
    @IBOutlet weak var total: UIView!
    @IBOutlet weak var labeltotal: UILabel!
    @IBOutlet weak var aMap: GMSMapView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var payment: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phone: UIView!
    
    
    var currentLocation: CLLocation?
    var marker = GMSMarker()
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        if Cart.currentCart.cartItems.count != 0 {
            self.products.isHidden = false
            self.address.isHidden = false
            self.payment.isHidden = false
            self.map.isHidden = false
            self.total.isHidden = false
            self.phone.isHidden = false
            
            loadProducts()
        }else{
            let empty = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
            empty.text = "The cart is empty and select products first"
            empty.center = self.view.center
            empty.textAlignment = NSTextAlignment.center
            
            
            self.view.addSubview(empty)
        }
        
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            placesClient = GMSPlacesClient.shared()
        }
        
        
    }
    
    func loadProducts(){
        self.products.reloadData()
        self.labeltotal.text = "$\(Cart.currentCart.getTotal())"
    }
    
    
    
    
    @IBAction func payment(_ sender: Any) {
        if self.addressTextField.text != "" {
            Cart.currentCart.address = addressTextField.text
            self.performSegue(withIdentifier: "payment", sender: self)
            
        }else{
            let alert = UIAlertController(title: "No address", message: "Please input the address.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: {(alert) in
                self.addressTextField.becomeFirstResponder()
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        if self.phoneTextField.text != "" {
            Cart.currentCart.phone = phoneTextField.text
            self.performSegue(withIdentifier: "payment", sender: self)
            
        }else{
            let alert = UIAlertController(title: "No phone", message: "Please input the phone.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: {(alert) in
                self.addressTextField.becomeFirstResponder()
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "payment"{
            let controller = segue.destination as! PaymentViewController
            controller.type = "default"
        }
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cart.currentCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartTableViewCell
        
        let cart = Cart.currentCart.cartItems[indexPath.row]
        cell.quantity.text = "\(cart.quantity)"
        cell.name.text = "\(cart.product.name!)"
        cell.subtotal.text = "$\(cart.product.price! * Float(cart.quantity))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Cart.currentCart.cartItems.remove(at: indexPath.row)
            
            products.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}
extension CartViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == addressTextField{
        let tempinputaddress = textField.text
        Cart.currentCart.address = tempinputaddress
        let inputaddress = tempinputaddress?.replacingOccurrences(of: " ", with: "%20")
        APIManager.shared.getCoordinates(inputaddress: inputaddress!) { (lat, lng) in
            let camera = GMSCameraPosition.camera(withLatitude: lat,
                                                  longitude: lng,
                                                  zoom: 16)
            // self.aMap.setRegion(region, animated: true)
            self.aMap.camera = camera
            self.locationManager.stopUpdatingLocation()
            self.marker.position.latitude=lat
            self.marker.position.longitude=lng
            self.marker.map = self.aMap
            }
        } else {
            Cart.currentCart.phone = textField.text
        }
        
        return true
    }
}


extension CartViewController: CLLocationManagerDelegate{
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
