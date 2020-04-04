//
//  Shop.swift
//  FYP
//
//  Created by yoshi on 10/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import Foundation
import SwiftyJSON

class Shop{
    var id: Int?
    var name: String?
    var address: String?
    var logo: String?
    var category: String?
    
    init(json:JSON){
        self.id = json["id"].int
        self.name = json["name"].string
        self.address = json["address"].string
        self.logo = json["logo"].string
        self.category = json["category"].string
    }
    
}
