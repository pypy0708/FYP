//
//  CartViewController.swift
//  FYP
//
//  Created by yoshi on 5/2/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class CartViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var address: UIView!
    @IBOutlet weak var products: UITableView!
    @IBOutlet weak var map: UIView!
    @IBOutlet weak var total: UIView!
    @IBOutlet weak var labeltotal: UILabel!
    @IBOutlet weak var aMap: MKMapView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var payment: UIButton!
    //    let navBar = UINavigationBar()
    //    let menuBarButton = UIButton(type: .custom)
    //    var barButton = UIBarButtonItem()
    //    func setNavigationBar() {
    //        let navItem = UINavigationItem(title: "")
    //
    //        //set image for button
    //        menuBarButton.setImage(UIImage(named: "icons8-menu-48"), for: .normal)
    //        //add function for button
    //        menuBarButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    //        //set frame
    //         if self.revealViewController() != nil{
    //        menuBarButton.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    //        }
    //        menuBarButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    //
    //        barButton = UIBarButtonItem(customView: menuBarButton)
    //        //assign button to navigationbar
    //
    //        navItem.leftBarButtonItem = barButton
    //        navBar.setItems([navItem], animated: false)
    //
    //        self.view.addSubview(navBar)
    //        navBar.translatesAutoresizingMaskIntoConstraints = false
    //        navBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
    //        navBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    //        navBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    //  }
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
            
            self.aMap.showsUserLocation = true
        }
        
        //        self.setNavigationBar()
        //        tableview.topAnchor.constraint(equalTo: navBar.layoutMarginsGuide.bottomAnchor).isActive = true
        
        //        if self.revealViewController() != nil{
        //            menuBarButton.target = self.revealViewController()
        //            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
        //            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //        }
    }
    
    func loadProducts(){
        self.products.reloadData()
        self.labeltotal.text = "$\(Cart.currentCart.getTotal())"
    }
    
    
    
    //    @objc func cart(){
    //        print("clicked")
    //        let homeView  = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
    //
    //        self.present(homeView, animated: true, completion: nil)
    //    }
    
    @IBAction func payment(_ sender: Any) {
        if self.addressTextField.text != "" {
            Cart.currentCart.address = addressTextField.text
            self.performSegue(withIdentifier: "payment", sender: self)
        }else{
            let alert = UIAlertController(title: "No address", message: "Please input the adress", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: {(alert) in
                self.addressTextField.becomeFirstResponder()
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
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
}
extension CartViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let inputaddress = textField.text
        let geocoder = CLGeocoder()
        Cart.currentCart.address = inputaddress
        geocoder.geocodeAddressString(inputaddress!){ (plackmarks, error)in
            if (error != nil ){
                print("Error: ", error)
            }
                        if let placemark = plackmarks?.first{
                            let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                            let region = MKCoordinateRegion(
                                center: coordinates,
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            )
                            self.aMap.setRegion(region, animated: true)
                            self.locationManager.stopUpdatingLocation()
            
                            let pin = MKPointAnnotation()
                            pin.coordinate = coordinates
            
                            self.aMap.addAnnotation(pin)
                        }
//            let center = CLLocationCoordinate2D(latitude: 22.3344859802915, longitude: 114.1914869802915)
//            let region = MKCoordinateRegion(center:center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//            let pin = MKPointAnnotation()
//            pin.coordinate = center
//            print(pin.coordinate)
//
//            self.aMap.addAnnotation(pin)
            
        }
        return true
    }
}

extension CartViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.aMap.setRegion(region, animated: true)
    }
}
