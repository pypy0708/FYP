//
//  FBManager.swift
//  FYP
//
//  Created by yoshi on 9/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import SwiftyJSON

class FBManager {
    //static for singleton
    static let shared = LoginManager()
    public class func getUserData(completionHandler: @escaping () -> Void){
        if (AccessToken.current != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "name, email, picture.type(normal)"]).start(completionHandler: { (connection, result, error) in
                
                if (error == nil){
                    let json = JSON(result!)
                    print(json)
                    User.currentUser.setInfo(json: json)
                    completionHandler()
                }
            })
        }
    }
    
 
}
