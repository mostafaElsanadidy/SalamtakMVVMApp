//
//  APIClient_Ext.swift
//  RecipesApp
//
//  Created by mostafa elsanadidy on 27.05.22.
//

import Foundation
import SwiftyJSON

extension APIClient {
    
    // MARK: - Get Error
    static func getError(json:JSON) -> String {
//        if   json["error"].count >= 1   {
//            let error = json["error"][0].stringValue
//            DispatchQueue.main.async {
//
//                //                ad.CurrentRootVC()?.showSimpleDAlert(subTitle: error, type: .error, autoDismiss: true)
//            }
//            return error
//        }else
        if let succes = json["Success"].bool {
            
            return succes ? "Done!".localized : "Failed".localized
            
        } else {
            return json["EnglishMessage"].string ?? "Network Connection Error".localized
        }
    }
    
}
