//
//  tools.swift
//  FYP
//
//  Created by yoshi on 11/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import Foundation

class Tools {
    

    
    static func loadImage(_ imageView: UIImageView,_ urlString: String) {
        let imgURL: URL = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: imgURL) { (data, response, error) in
            
            guard let data = data, error == nil else { return}
            
            DispatchQueue.main.async(execute: {
                imageView.image = UIImage(data: data)
            })
            }.resume()
        
    }

    
    static func showLoading(_ loading: UIActivityIndicatorView,_ view: UIView) {
        
        loading.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        loading.center = view.center
        loading.hidesWhenStopped = true
        loading.style = UIActivityIndicatorView.Style.whiteLarge
        loading.color = UIColor.black
        
        view.addSubview(loading)
        loading.startAnimating()
    }
    

    static func stopLoading(_ loading: UIActivityIndicatorView) {
        loading.stopAnimating()
    }
    
}
