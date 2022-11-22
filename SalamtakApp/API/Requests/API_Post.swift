//
//  API_Post.swift
//  RecipesApp
//
//  Created by mostafa elsanadidy on 27.05.22.
//

import Foundation
import Alamofire
import SwiftyJSON

extension APIClient{
    
    // MARK: - Search For Recipes
    static func searchForRecipe(indexFrom:String, indexTo:String, serchKey:String, completionHandler : @escaping (Result<[Complaint]? , Result_Error>) -> Void ) {
        
        ad.isLoading()
        performSwiftyRequest(route: .searchForMedicationItems(IndexFrom: indexFrom, IndexTo: indexTo, serchKey: serchKey), { (jsonData) in
            let json = JSON(jsonData)

            guard let success = json["Success"].bool, !success else {
               
                DispatchQueue.main.async {
                    ad.killLoading()
                    let data = RootClass(fromJson: json).complaints
                    completionHandler(.success(data))
                }
                return
            }

            ad.killLoading()
//            "please check connecting to internet and try again"
//            let sms = getError(json: json)
            ad.CurrentRootVC()?.show_Popup(body: "there isn't current results please try again later", type: .single, status: .failure)
            completionHandler(.failure(.status_Failure))
            
        }, _: { (error) in
            ad.killLoading()
            DispatchQueue.main.async {
                ad.CurrentRootVC()?.show_Popup(body: (error as? NSError)?.localizedDescription ?? "" , type: .single, status: .failure)
                completionHandler(.failure(.req_Failure))
            }
        })

    }
    
}
