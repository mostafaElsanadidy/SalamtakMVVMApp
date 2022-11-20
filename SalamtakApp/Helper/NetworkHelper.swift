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
    
    static var userID: Int?{
        didSet{
            UserDefaults.standard.set(userID, forKey: "userID")
        }
    }
    
    static var phone: String?{
        didSet{
            UserDefaults.standard.set(phone, forKey: "phone")
        }
        
    }
    static var avatar: String?{
        didSet{
            UserDefaults.standard.set(avatar, forKey: "avatar")
        }
    }
    
    //MARK:- GET USER DATA
    static func getName() -> String? {
        if let name = UserDefaults.standard.value(forKey: "name") as? String{
            NetworkHelper.name = name
        }
        return NetworkHelper.name
    }
    
    static func getUserId() -> Int? {
        if let userID = UserDefaults.standard.value(forKey: "userID") as? Int{
            NetworkHelper.userID = userID
        }
        return NetworkHelper.userID
    }
    
    
    static func getPhone() -> String? {
        if let phone = UserDefaults.standard.value(forKey: "phone") as? String{
            NetworkHelper.phone = phone
        }
        return NetworkHelper.phone
    }
    
    static func getAvatar() -> String? {
        if let avatar = UserDefaults.standard.value(forKey: "avatar") as? String{
            NetworkHelper.avatar = avatar
        }
        return NetworkHelper.avatar
    }
    
    
    
    static func userLogout() {
        UserDefaults.standard.set(nil, forKey: "Logged")
        NetworkHelper.name = nil
        UserDefaults.standard.removeObject(forKey: "name")
        NetworkHelper.userID = nil
        UserDefaults.standard.removeObject(forKey: "userID")
        NetworkHelper.phone = nil
        UserDefaults.standard.removeObject(forKey: "phone")
        NetworkHelper.avatar = nil
        UserDefaults.standard.removeObject(forKey: "avatar")
    }
    
    
    
    
}
