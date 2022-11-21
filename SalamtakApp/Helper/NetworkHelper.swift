//
//  NetworkHelper.swift
//  MadeInKuwait
//
//  Created by Amir on 3/14/20.
//  Copyright © 2020 Amir. All rights reserved.
//

import Foundation

class NetworkHelper {
    
    
    //MARK:- SAVE USER DATA
    static var name: String?{
        didSet{
            UserDefaults.standard.set(name, forKey: "name")
        }
    }
    
    //MARK:- GET USER DATA
    static func getName() -> String? {
        if let name = UserDefaults.standard.value(forKey: "name") as? String{
            NetworkHelper.name = name
        }
        return NetworkHelper.name
    }
    
    
    static func userLogout() {
//        UserDefaults.standard.set(nil, forKey: "Logged")
        NetworkHelper.name = nil
        UserDefaults.standard.removeObject(forKey: "name")
    }
    
    
    
    
}
