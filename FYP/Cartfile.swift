//
//  Cart.swift
//  FYP
//
//  Created by yoshi on 12/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import Foundation
import SwiftyJSON

class CartItem{
    var product: Product
    var quantity: Int
    
    init(product: Product, quantity: Int){
    self.product = product
    self.quantity = quantity
    }
}

class Cart{
    
    var cartItems = [CartItem]()
    var shop: Shop?
    var address: String?
    var phone: String?
    
    //singleton because users can only order from one shop at the same time
    static let currentCart = Cart()
    
    func getTotal() -> Float{
        var total: Float = 0
        for cartItem in self.cartItems{
            total += Float(cartItem.quantity) * cartItem.product.price!
        }
        return total
    }
    
    func reset(){
        self.shop = nil
        self.address=nil
        self.phone=nil
        self.cartItems = []
        
    }
    
}

class customizedCartItem{
    var productName: String
    var quantity: Int
    var price: Float
    
    init(productName: String, quantity: Int, price: Float){
    self.productName = productName
    self.quantity = quantity
    self.price = price
    }
}

class customizedCart{
    var customizedCartItems = [customizedCartItem]()
    var shopName: String?
    var shopAddress: String?
    var customerAddress: String?
    var customerPhone: String?
    
    //singleton because users can only order from one shop at the same time
    static let currentCustomizedCart = customizedCart()
    
    func getTotal() -> Float{
        var total: Float = 0
        for item in self.customizedCartItems{
            total += Float(item.quantity) * item.price
        }
        return total
    }
    
    func reset(){
        self.shopName = nil
        self.shopAddress=nil
        self.customerAddress=nil
        self.customerPhone=nil
        self.customizedCartItems = []
        
    }
}
