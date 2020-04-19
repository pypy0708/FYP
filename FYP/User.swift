//
//  User.swift
//  FYP
//
//  Created by yoshi on 9/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    var name:  String?
    var email: String?
    var pictureURL: String?
//    var tempname: String?
//    var tempemail: String?
//    var tempURL: String?

    static let currentUser = User()
    
//    func refresh(){
//        self.name = tempname
//        self.email = tempemail
//        self.pictureURL = tempURL
//
//    }
    func setInfo(json: JSON){
        self.name = json["name"].string
        self.email = json["email"].string
        let image = json["picture"].dictionary
        let imageData = image?["data"]?.dictionary
        self.pictureURL = imageData?["url"]?.string
//        tempname=self.name
//        tempemail=self.email
//        tempURL=self.pictureURL

        

//        print(User.currentUser.name!)
//        print(json["name"].string!)
//        print(self.name!)
    }
    
    func resetInfo(){
        self.name = nil
        self.email = nil
        self.pictureURL = nil
    }
}
