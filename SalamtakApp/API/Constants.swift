////
////  Constants.swift
////  MadeInKuwait
////
////  Created by Amir on 1/29/20.
////  Copyright © 2020 Amir. All rights reserved.
////

import Alamofire

struct Constants {
    
    static var deviceID = UIDevice.current.identifierForVendor!.uuidString
    static let randomQueue =  DispatchQueue(label: "randomQueue", qos: .utility)
    
    struct ProductionServer {
        static let baseURL = "http://40.127.194.127:5656/Salamtak/"
    }
    
    enum APIParameters :String{
        case Code
        case Success
    }
    
    enum HTTPHeaderField: String {
        case token = "x-access-token"
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
        case Language = "Accept-Language"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
}

