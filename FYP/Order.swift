//
//  Order.swift
//  FYP
//
//  Created by yoshi on 6/4/2020.
//  Copyright © 2020 py. All rights reserved.
//

import Foundation
import SwiftyJSON

class Order{
    var id: Int?
    var customerName: String?
    var customerAddress: String?
    var shopName: String?
    var shopAddress: String?
    var total: Double?
    var date: String?
    var type: String?
    
    init(json: JSON,type: String){
        if type == "default"{
            self.id = json["id"].int
            self.customerName = json["customer"]["name"].string
            self.customerAddress = json["customer"]["address"].string
            self.shopName = json["shop"]["name"].string
            self.shopAddress = json["shop"]["address"].string
            self.total = json["total"].double
            self.date = json["order_time"].string
            self.type = type
        }else{
            self.id = json["id"].int
            self.customerName = json["customer"]["name"].string
            self.customerAddress = json["customer"]["address"].string
            self.shopName = json["shopname"].string
            self.shopAddress = json["shopaddress"].string
            self.total = json["total"].double
            self.date = json["order_time"].string
            self.type = type
        }
        
    }
}
