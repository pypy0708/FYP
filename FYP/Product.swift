//
//  Product.swift
//  FYP
//
//  Created by yoshi on 11/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import Foundation
import SwiftyJSON

class Product{
    var id: Int?
    var name: String?
    var description: String?
    var price: Float?
    var image: String?
    
    
    init(json:JSON){
        self.id = json["id"].int
        self.name = json["name"].string
        self.description = json["description"].string
        self.price = json["price"].float
        self.image = json["image"].string
    }
    
}
