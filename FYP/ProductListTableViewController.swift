//
//  ProductListTableViewController.swift
//  FYP
//
//  Created by yoshi on 5/2/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class ProductListTableViewController: UITableViewController {
    
    var shop: Shop?
    var products = [Product]()
    let loading  = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let shopName = shop?.name{
            self.navigationItem.title = shopName
        }
        loadProducts()
    }
    
    func loadProducts (){
        Tools.showLoading(loading,view)
        if let shopID = shop?.id{
            APIManager.shared.getProducts(shopID: shopID, completionHandler: { (json) in
                if json != nil {
                    self.products = []
                    if let productList = json!["products"].array{
                        for item in productList{
                            let product = Product(json: item)
                            self.products.append(product)
                        }
                        self.tableView.reloadData()
                        Tools.stopLoading(self.loading)
                    }
                }
            })
        }
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        let product = products[indexPath.row]
        cell.productName.text = product.name
        cell.aDescription.text = product.description
        if let price = product.price{
            cell.price.text = "$\(price)"
        }
        if let imageURL = product.image{
            Tools.loadImage( cell.aImage, "\(imageURL)")
        }
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductDetail"{
            let controller = segue.destination as! ProductDetailViewController
            controller.product = products[(tableView.indexPathForSelectedRow?.row)!]
            controller.shop = shop
        }
    }

}
