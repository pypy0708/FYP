
//
//  APIManager.swift
//  FYP
//
//  Created by yoshi on 10/3/2020.
//  Copyright © 2020 py. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import FBSDKLoginKit

class APIManager{
    static let shared = APIManager()
    
    let baseURL = NSURL(string: BASE_URL)
    
    var accessToken = ""
    var refreshToken = ""
    var expired = Date()
    
    
    func login(userType: String, completionHandler: @escaping (NSError?) -> Void ){
        let path = "api/social/convert-token/"
        let url = baseURL!.appendingPathComponent(path)
        let params: [String: Any] = [
            "grant_type": "convert_token",
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "backend": "facebook",
            "token": AccessToken.current!.tokenString,
            "user_type": userType
        ]
        
        AF.request(url!, method: .post, parameters: params,  headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                
                let jsonData = JSON(value)
                
                self.accessToken = jsonData["access_token"].string!
                self.refreshToken = jsonData["refresh_token"].string!
                self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                completionHandler(nil)
                break
                
            case .failure(let error):
                completionHandler(error as NSError?)
                break
                
            }
        }
    }
    
    func logout(completionHandler: @escaping (NSError?) -> Void) {
        
        let path = "api/social/revoke-token/"
        let url = baseURL!.appendingPathComponent(path)
        let params: [String: Any] = [
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "token": self.accessToken
        ]
        
        AF.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseString { (response) in
            
            switch response.result {
            case .success:
                completionHandler(nil)
                break
                
            case .failure(let error):
                completionHandler(error as NSError?)
                break
            }
        }
    }
    
    func refreshToken(completionHandler: @escaping () -> Void) {
        
        let path = "api/social/refresh-token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "access_token": self.accessToken,
            "refresh_token": self.refreshToken
        ]
        if (Date() > self.expired) {
            AF.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    self.accessToken = jsonData["access_token"].string!
                    self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                    completionHandler()
                    break
                    
                case .failure:
                    break
                }
            })
        } else {
            completionHandler()
        }
    }
    
    func requestServer(_ method: Alamofire.HTTPMethod,_ path: String,_ params: [String: Any]?,_ encoding: ParameterEncoding,_ completionHandler: @escaping (JSON?) -> Void ) {
        
        let url = baseURL?.appendingPathComponent(path)
        
        refreshToken {
            
            AF.request(url!, method: method, parameters: params, encoding: encoding, headers: nil).responseJSON{ response in
                
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    completionHandler(jsonData)
                    break
                    
                case .failure:
                    completionHandler(nil)
                    break
                }
            }
        }
        
    }
    
    func getShops(completionHandler: @escaping (JSON?) -> Void) {
        
        let path = "api/customer/shops/"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
        //        let url = baseURL?.appendingPathComponent(path)
        //
        //        refreshToken {
        //
        //            AF.request(url!, method: .get, parameters: nil, encoding: URLEncoding(), headers: nil).responseJSON(completionHandler: { (response) in
        //
        //                switch response.result {
        //                case .success(let value):
        //                    let jsonData = JSON(value)
        //                    completionHandler(jsonData)
        //                    break
        //
        //                case .failure:
        //                    completionHandler(nil)
        //                    break
        //                }
        //            })
        //        }
    }
    
    func getProducts (shopID: Int, completionHandler: @escaping(JSON?) -> Void){
        let path = "api/customer/products/\(shopID)"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
    }
    
    func addOrder(stripeToken: String, completionHandler: @escaping(JSON?) -> Void){
        let path = "api/customer/order/add/"
        let array = Cart.currentCart.cartItems
        let jsonArray = array.map{ item in
            return[
                "product_id": item.product.id!,
                "quantity": item.quantity
            ]
        }
        if JSONSerialization.isValidJSONObject(jsonArray){
            do{
                let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                let params:[ String: Any] = [
                    "access_token": self.accessToken,
                    "stripe_token": stripeToken,
                    "shop_id": "\(Cart.currentCart.shop!.id!)",
                    "order_details": dataString,
                    "address": Cart.currentCart.address!
                ]
                requestServer(.post, path, params, URLEncoding(), completionHandler)
            }
            catch{
                print("JSON Serialization failed: \(error)")
            }
        }
    }
    
    func getOrder(completionHandler: @escaping (JSON?) -> Void){
        let path = "api/customer/order/latest/"
        let params: [String: Any] = [
            "access_token": self.accessToken
        ]
        
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    func getCoordinates (inputaddress: String, completionHandler: @escaping(Double,Double) -> Void){
        requestCoor(.get, URLEncoding(),inputaddress, completionHandler)
    }
    
    func requestCoor(_ method: Alamofire.HTTPMethod,_ encoding: ParameterEncoding,_ inputaddress: String,_ completionHandler: @escaping (Double,Double) -> Void ) {
        let url = "https://maps.googleapis.com/maps/api/geocode/json?address=\(inputaddress),+CA&key=\(GOOGLE_API_KEY)"
        
        AF.request(url, method: method, encoding: encoding).responseJSON{ response in
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                //print(jsonData)
                let lat = jsonData["results"][0]["geometry"]["location"]["lat"].double!
                let lng = jsonData["results"][0]["geometry"]["location"]["lng"].double!
                completionHandler(lat,lng)
                break
                
            case .failure:
                break
            }
        }
    }
    func getPath (deslat: Double, deslng: Double, sourcelat: Double,sourcelng: Double, completionHandler: @escaping(String) -> Void){
        requestPath(.get, URLEncoding(),deslat,deslng,sourcelat,sourcelng, completionHandler)
    }
    
    func requestPath(_ method: Alamofire.HTTPMethod,_ encoding: ParameterEncoding,_ deslat: Double,_ deslng: Double,_ sourcelat: Double,_ sourcelng: Double,_ completionHandler: @escaping (String) -> Void ) {
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourcelat),\(sourcelng)&destination=\(deslat),\(deslng)&mode=walking&key=\(GOOGLE_API_KEY)"
        AF.request(url, method: method, encoding: encoding).responseJSON{ response in
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                //let pathDict = jsonData["routes"][0]["overview_polyline"]
                let polyline = jsonData["routes"][0]["overview_polyline"]["points"].string!
                print(polyline)
//                let steps = pathDict.arrayValue
//                var pointsArray = [String]()
//                for step in steps{
//                    pointsArray.append(step["polyline"]["points"].string!)
//                }
//                print(pointsArray)
                
                
                completionHandler(polyline)
                break
                
            case .failure:
                break
            }
        }
    }
    
    func deliveryManGetOrder(completionHandler: @escaping (JSON?) -> Void){
        let path = "api/deliveryman/orders/ready/"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
    }
    
    func acceptOrder(orderId: Int, completionHandler: @escaping (JSON?) -> Void){
        let path = "api/deliveryman/orders/pick/"
        let params: [String: Any] = [
            //server does not recognise unless it is a string
            "order_id": "\(orderId)",
            "access_token": self.accessToken
        ]
        requestServer(.post, path, params, URLEncoding(), completionHandler)
    }
    
    func deliverymanGetOrderDetails(completionHandler: @escaping (JSON?) -> Void){
        let path = "api/deliveryman/orders/latest/"
        let params: [String: Any] = [
            "access_token": self.accessToken
        ]
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    
    func updateLocation(lat: Double, lng: Double, completionHandler: @escaping (JSON?) -> Void){
        let path = "api/deliveryman/location/update/"
        let params: [String: Any] = [
            "access_token": self.accessToken,
            "location": "\(lat),\(lng)"
        ]
        requestServer(.post, path, params, URLEncoding(), completionHandler)
    }
    
    func getLocation(completionHandler: @escaping (JSON?) -> Void){
        let path = "api/customer/location/get/"
        let params: [String: Any] = [
            "access_token": self.accessToken
        ]
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    
    func completerOrder(orderId: Int,completionHandler: @escaping (JSON?) -> Void){
        let path = "api/deliveryman/orders/complete/"
        let params: [String: Any] = [
            "access_token": self.accessToken,
            "order_id": "\(orderId)"
        ]
        requestServer(.post, path, params, URLEncoding(), completionHandler)
    }
}





