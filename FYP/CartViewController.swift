//
//  CartViewController.swift
//  FYP
//
//  Created by yoshi on 5/2/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {


    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
//    let navBar = UINavigationBar()
//    let menuBarButton = UIButton(type: .custom)
//    var barButton = UIBarButtonItem()
//    func setNavigationBar() {
//        let navItem = UINavigationItem(title: "")
//
//        //set image for button
//        menuBarButton.setImage(UIImage(named: "icons8-menu-48"), for: .normal)
//        //add function for button
//        menuBarButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
//        //set frame
//         if self.revealViewController() != nil{
//        menuBarButton.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
//        menuBarButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
//
//        barButton = UIBarButtonItem(customView: menuBarButton)
//        //assign button to navigationbar
//
//        navItem.leftBarButtonItem = barButton
//        navBar.setItems([navItem], animated: false)
//
//        self.view.addSubview(navBar)
//        navBar.translatesAutoresizingMaskIntoConstraints = false
//        navBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
//        navBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        navBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
//  }
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    
//        self.setNavigationBar()
//        tableview.topAnchor.constraint(equalTo: navBar.layoutMarginsGuide.bottomAnchor).isActive = true
        
//        if self.revealViewController() != nil{
//            menuBarButton.target = self.revealViewController()
//            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
    }
    
    
    
//    @objc func cart(){
//        print("clicked")
//        let homeView  = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
//
//        self.present(homeView, animated: true, completion: nil)
//    }

    

}

extension CartViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath)
        
        return cell
    }
}
