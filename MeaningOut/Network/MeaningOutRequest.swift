//
//  MeaningOutRequest.swift
//  MeaningOut
//
//  Created by 강석호 on 6/26/24.
//

import UIKit
import Alamofire

enum TMDBRequest {
    case meaningOut
    
    var baseURL: String {
        return APIURL.naverSearchURL
    }
    
    var endpoint: String {
        switch self {
        case .meaningOut:
            return "\(baseURL)"
        }
    }
    
    var headers: HTTPHeaders {
        return [
            "accept": "application/json"
        ]
    }
    
    var parameters: Parameters {
        return ["api_key": APIKey.naverID]
    }
}
