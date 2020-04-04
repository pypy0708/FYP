//
//  ViewController.swift
//  FYP
//
//  Created by yoshi on 4/2/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    var fbLoginSuccess = false
    
    
    @IBOutlet weak var switchType: UISegmentedControl!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    var userType: String = USERTYPE_CUSTOMER
    
    
    @IBAction func facebookLogin(_ sender: Any) {
        
        if (AccessToken.current != nil) {
            
            APIManager.shared.login(userType: userType, completionHandler: { (error ) in
                if error == nil {
                    self.fbLoginSuccess = true
                    self.viewDidAppear(true)
                }
            })
            
        } else {
            
            FBManager.shared.logIn(
                permissions: ["public_profile", "email"],
                from: self,
                handler:{ (result, error) in
                    if (error == nil){
                        
                        FBManager.getUserData(completionHandler: {
                            APIManager.shared.login(userType: self.userType, completionHandler: { (error ) in
                                if error == nil {
                                    self.fbLoginSuccess = true
                                    self.viewDidAppear(true)
                                }
                            })
                        })
                        
                    }
                    
            })
        }
        
    }
    
    @IBAction func facebookLogout(_ sender: Any) {
        APIManager.shared.logout{(error) in
            FBManager.shared.logOut()
            User.currentUser.resetInfo()
            self.logoutButton.isHidden = true
            self.loginButton.setTitle("Login with Facebook", for: .normal)
            
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if (AccessToken.current != nil){
            
            logoutButton.isHidden = false
            FBManager.getUserData(completionHandler: {
                self.loginButton.setTitle("Continue as \(User.currentUser.email!)", for: .normal)
            })
        }
        else {
            self.logoutButton.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userType = userType.capitalized
        if (AccessToken.current != nil && fbLoginSuccess == true){
            performSegue(withIdentifier: "\(userType)View", sender: self)
        }
    }
    
    @IBAction func switchTypeButton(_ sender: Any) {
        let type = switchType.selectedSegmentIndex
        
        if type == 0{
            userType = USERTYPE_CUSTOMER
        }else{
            userType = USERTYPE_DELIVERYMAN
        }
    }
    
}


