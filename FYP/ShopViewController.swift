//
//  ShopViewController.swift
//  FYP
//
//  Created by yoshi on 4/2/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil{
        menuBarButton.target = self.revealViewController()
        menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
        loadShops()
    }
    @IBOutlet weak var search: UISearchBar!
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    var shops = [Shop]()
    var searchShopResult = [Shop]()
    @IBOutlet weak var shopTableView: UITableView!
    let loading  = UIActivityIndicatorView()
    
    func loadShops (){
        Tools.showLoading(loading,view)
        APIManager.shared.getShops{ (json) in
            if json != nil{
                self.shops = []
                if let shopList = json!["shops"].array{
                    for item in shopList{
                        let shop = Shop(json: item)
                        self.shops.append(shop)
                    }
                    self.shopTableView.reloadData()
                    Tools.stopLoading(self.loading)
                }
            }
            
        }
    }
    


}

extension ShopViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search.text != ""{
            return self.searchShopResult.count
        }
        return self.shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath) as! ShopTableViewCell
        
        let shop: Shop
        if search.text != ""{
            shop = searchShopResult[indexPath.row]
        } else{
            shop = shops[indexPath.row]
        }
        cell.shopName.text = shop.name!
        cell.shopAddress.text = shop.address!
        if let logoURL = shop.logo{
            Tools.loadImage( cell.shopLogo,  "\(logoURL)")
        }
    
    return cell
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductList"{
            let controller = segue.destination as! ProductListTableViewController
            controller.shop = shops[(shopTableView.indexPathForSelectedRow?.row)!]
        }
    }
}

extension ShopViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchShopResult = self.shops.filter({ (res: Shop) -> Bool in
            
            return res.name?.lowercased().range(of: searchText.lowercased()) != nil
        })
        
        self.shopTableView.reloadData()
    }
}
