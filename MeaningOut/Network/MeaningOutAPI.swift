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
        let request = TMDBRequest.meaningOutSearch
        var parameters = request.parameters
        parameters["query"] = query
        parameters["display"] = "10"
        parameters["start"] = "\(page)"
        
        AF.request(request.endpoint, parameters: parameters, headers: request.headers)
            .responseDecodable(of: SearchResponse.self) { response in
                completion(response.result)
            }
    }
    
    func fetchSearchResultsWithURLSession(query: String, page: Int, delegate: URLSessionDataDelegate) {
        let request = TMDBRequest.meaningOutSearch
        var components = URLComponents(string: request.endpoint)!
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "display", value: "10"),
            URLQueryItem(name: "start", value: "\(page)")
        ]
        
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = request.headers.dictionary
        
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: .main)
        let task = session.dataTask(with: urlRequest)
        task.resume()
    }
}
