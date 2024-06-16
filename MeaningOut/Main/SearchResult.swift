//
//  SearchResult.swift
//  MeaningOut
//
//  Created by 강석호 on 6/16/24.
//

import Foundation

struct SearchResult: Decodable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
}

struct SearchResponse: Decodable {
    let items: [SearchResult]
}
