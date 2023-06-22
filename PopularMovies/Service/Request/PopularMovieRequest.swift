//
//  PopularMovieRequest.swift
//  PopularMovies
//
//  Created by Tifo Audi Alif Putra on 11/08/21.
//

import Foundation

struct PopularMovieRequest: DataRequest {
    
    private let apiKey: String = "020e7b126f0ee278311159ff7dd3028c"
    internal var page: Int = 1
    
    init(page: Int) {
        self.page = page
    }
    
    var url: String {
        let baseURL: String = "https://api.themoviedb.org/3"
        let path: String = "/movie/popular"
        return baseURL + path
    }
    
    var headers: [String : String] {
        [:]
    }
    
    var queryItems: [String : String] {
        [
            "api_key": apiKey,
            "page" : "\(page)"
        ]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    //    func decode(_ data: Data) throws -> [Movie] {
    //        let decoder = JSONDecoder()
    //        decoder.keyDecodingStrategy = .convertFromSnakeCase
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-mm-dd"
    //        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    //
    //        let response = try decoder.decode(MoviesResponse.self, from: data)
    //        return response.results
    //    }
    
    func decode(_ data: Data) throws -> MoviesResponse {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let response = try decoder.decode(MoviesResponse.self, from: data)
        return response
    }
}
