//
//  MeaningOutRequest.swift
//  MeaningOut
//
//  Created by 강석호 on 6/26/24.
//

import UIKit
import Alamofire

enum TMDBRequest {
    case meaningOutSearch
    
    var baseURL: String {
        return APIURL.naverSearchURL
    }
    
    var endpoint: String {
        switch self {
        case .meaningOutSearch:
            return baseURL
        }
    }
    
    var headers: HTTPHeaders {
        return [
            "accept": "application/json",
            "X-Naver-Client-Id": APIKey.naverID,
            "X-Naver-Client-Secret": APIKey.naverSecret
        ]
    }
    
    var parameters: Parameters {
        return [:]
    }
}
