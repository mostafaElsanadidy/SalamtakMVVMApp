//
//  ApiClient.swift
//  MadeInKuwait
//
//  Created by Amir on 1/29/20.
//  Copyright © 2020 Amir. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIClient {

    @discardableResult
    static func performSwiftyRequest(route:APIRouter,_ completion:@escaping (JSON)->Void,_ failure:@escaping (Error?)->Void) -> DataRequest {
        
        return AF.request(route).response{ (response) in
//            print(response)
                   switch response.result {
                   case .success :
                    guard let _ = response.value
                        else {
                           failure(response.error)
                           return
                       }
//                       print(response.result , route.urlRequest as Any)
                       let json = JSON(response.value as Any)
//                       print(json)
                       
                       completion(json)
                      
                   case .failure( _):
                       failure(response.error)
                   }
               }
       }

    static func cancelAllRequests(completed : @escaping ()->() ) {
        AF.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
            completed()
        }
    }
    
    
   
}
