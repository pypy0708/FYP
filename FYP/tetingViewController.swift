//
//  tetingViewController.swift
//  FYP
//
//  Created by yoshi on 15/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import UIKit
import GoogleMaps
class tetingViewController: UIViewController {

    
    @IBOutlet weak var mapVIew: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 22.334879, longitude:  114.190235, zoom: 12.0)
        // Do any additional setup after loading the view.
        mapVIew.camera = camera
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
