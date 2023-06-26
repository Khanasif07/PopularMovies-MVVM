//
//  MovieDetailRequest.swift
//  PopularMovies
//
//  Created by Asif Khan on 26/06/2023.
//

import Foundation

struct MovieDetailRequest: DataRequest {
    
    private let apiKey: String = "020e7b126f0ee278311159ff7dd3028c"
    internal var path: String = ""
    
    init(path: String) {
        self.path = path
    }
    
    var url: String {
        let baseURL: String = "https://api.themoviedb.org"
        let path: String = "/3/movie/"
        return baseURL + path
    }
    
    var headers: [String : String] {
        [:]
    }
    
    var pathParam: String {
        path
    }
    
    var queryItems: [String : String] {
        [
            "api_key": apiKey
        ]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(_ data: Data) throws -> MovieDetail {
        let decoder = JSONDecoder()
        let response = try decoder.decode(MovieDetail.self, from: data)
        return response
    }
}
