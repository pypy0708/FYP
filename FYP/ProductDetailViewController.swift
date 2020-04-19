//
//  ProductDetailViewController.swift
//  FYP
//
//  Created by yoshi on 5/2/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var aImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var aDescription: UILabel!
    
    
    
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    var tempQuantity = 1
    var product : Product?
    var shop: Shop?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProduct()
       
    }
    
    @IBAction func increase(_ sender: Any) {
        tempQuantity += 1
        quantity.text = String(tempQuantity)
        
        if let  price = product?.price{
            subtotal.text = "$\(price * Float(tempQuantity))"
        }
    }
    @IBAction func decrease(_ sender: Any) {
        if tempQuantity > 1 {
            tempQuantity -= 1
            quantity.text = String(tempQuantity)
            if let  price = product?.price{
                subtotal.text = "$\(price * Float(tempQuantity))"
            }
        }
    }
    @IBAction func cart(_ sender: Any) {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        image.image = UIImage(named: "icons8-product-100")
        image.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-100)
        self.view.addSubview(image)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {image.center = CGPoint(x: self.view.frame.width - 40, y: 24)}, completion: {_ in
            image.removeFromSuperview()
            let cartItem = CartItem(product: self.product!, quantity :self.tempQuantity)
            //there are items in the cart
            guard let cartShop = Cart.currentCart.shop, let currentShop = self.shop
                else{
                    //there is not item in the cart
                    Cart.currentCart.shop = self.shop
                    Cart.currentCart.cartItems.append(cartItem)
                    return
            }
            //check whether the new product and the existed product are from the same shop
            if cartShop.id == currentShop.id{
                //check wheter the new product are added before.
                let inCart = Cart.currentCart.cartItems.firstIndex(where: { (item) -> Bool in
                    //print(item.product.id! == cartItem.product.id!)
                    return item.product.id! == cartItem.product.id!
                })
                
                if let index = inCart{
                    let alert = UIAlertController(
                        title: "Add more?",
                        message: "You have already order this product. Do you want to add more?",
                        preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                        
                        Cart.currentCart.cartItems[index].quantity += self.tempQuantity
                    })
                    
                    alert.addAction(confirmAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    Cart.currentCart.cartItems.append(cartItem)
                }
            }else{
                let alert = UIAlertController(
                    title: "Start a new cart?",
                    message: "You have already order from other shop. Do you want to clear the current cart?",
                    preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    
                    Cart.currentCart.cartItems = []
                    Cart.currentCart.cartItems.append(cartItem)
                    Cart.currentCart.shop = self.shop
                })
                alert.addAction(confirmAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    
    func loadProduct() {
        if let price = product?.price{
            subtotal.text = "$\(price)"
        }
        name.text = product?.name
        aDescription.text = product?.description
        if let imageURL = product?.image{
            Tools.loadImage(aImage, "\(imageURL)")
        }
    }
    
 
    
}
