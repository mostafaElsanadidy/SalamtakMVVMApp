//
//  RootClass.swift
//  Salamtak_App
//
//  Created by mostafa elsanadidy on 10.11.22.
//

import Foundation
import SwiftyJSON

class RootClass{

    var arabicMessage : String!
    var code : Int!
    var currentPage : Int!
    var englishMessage : String!
//    var isArabic : AnyObject!
    var pageCount : Int!
//    var selectedMedicines : AnyObject!
    var success : Bool!
//    var visitStatus : AnyObject!
    var complaints : [Complaint]!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        arabicMessage = json["ArabicMessage"].stringValue
        code = json["Code"].intValue
        currentPage = json["CurrentPage"].intValue
        englishMessage = json["EnglishMessage"].stringValue
//        isArabic = json["IsArabic"].stringValue as AnyObject
        pageCount = json["PageCount"].intValue
//        selectedMedicines = json["SelectedMedicines"].stringValue as AnyObject
        success = json["Success"].boolValue
//        visitStatus = json["VisitStatus"].stringValue as AnyObject
        complaints = [Complaint]()
        let complaintsArray = json["complaints"].arrayValue
        for complaintsJson in complaintsArray{
            let value = Complaint(fromJson: complaintsJson)
            complaints.append(value)
        }
    }

}
