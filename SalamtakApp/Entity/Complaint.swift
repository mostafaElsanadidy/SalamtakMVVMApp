//
//  Entity.swift
//  Salamtak
//
//  Created by mostafa elsanadidy on 06.11.22.
//

import Foundation
import SwiftyJSON
// model

class Complaint{

    var arabicName : String!
    var englishName : String!
    var id : String!
    var isDrug : Bool!
    var isLimited : Int!
    var oldPrice : Int!
    var picUrl : String!
    var price : Float!
    var quantity : Int!
    var code : String!
    var indexCount : Int!
    var pagesCount : Int!
//    marketing , soctt ( video calling ) , push notifications , parsing data from json ( integer,string ) , handle with two api , (xip view) , online paying , know when user add to cart , userdefaults , rxswifr instead of observer , ecommerce
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        arabicName = json["ArabicName"].stringValue
        englishName = json["EnglishName"].stringValue
        id = json["Id"].stringValue
        isDrug = json["IsDrug"].boolValue
        isLimited = json["IsLimited"].intValue
        oldPrice = json["OldPrice"].intValue
        picUrl = json["PicUrl"].stringValue
        price = json["Price"].floatValue
        quantity = json["Quantity"].intValue
        code = json["code"].stringValue
        indexCount = json["indexCount"].intValue
        pagesCount = json["pages_count"].intValue
    }

}

