//
//  MeaningOutAPI.swift
//  MeaningOut
//
//  Created by 강석호 on 6/26/24.
//

import UIKit
import Alamofire

class MeaningOutAPI {
    
    static let shared = MeaningOutAPI()
    
    private init() { }
    
    func fetchSearchResults(query: String, page: Int, completion: @escaping (Result<SearchResponse, AFError>) -> Void) {
        var request = TMDBRequest.meaningOutSearch
        var parameters = request.parameters
        parameters["query"] = query
        parameters["display"] = "10"
        parameters["start"] = "\(page)"
        
        AF.request(request.endpoint, parameters: parameters, headers: request.headers)
            .responseDecodable(of: SearchResponse.self) { response in
                completion(response.result)
            }
    }
}
