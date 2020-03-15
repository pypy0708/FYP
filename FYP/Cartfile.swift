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
        self.cartItems = []
        
    }
    
}
