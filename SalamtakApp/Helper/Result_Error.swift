//
//  Result_Error.swift
//  Zawidha
//
//  Created by Maher on 12/7/20.
//

import Foundation

enum Result_Error : Error {
    case req_Failure
    case status_Failure
    
    var error_Desc : String {
        switch self {
        case .req_Failure:
            return "Request Failed".localized
        case .status_Failure :
            return "Request Status Failure".localized
        }
    }
    
}
