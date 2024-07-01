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
    
    func fetchSearchResultsWithURLSession(query: String, page: Int, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
            let baseURL = "https://api.meaningout.com/search"
            var components = URLComponents(string: baseURL)!
            components.queryItems = [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "display", value: "10"),
                URLQueryItem(name: "start", value: "\(page)")
            ]
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    let statusCodeError = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                    completion(.failure(statusCodeError))
                    return
                }
                
                guard let data = data else {
                    let dataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])
                    completion(.failure(dataError))
                    return
                }
                
                do {
                    let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                    completion(.success(searchResponse))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
}
