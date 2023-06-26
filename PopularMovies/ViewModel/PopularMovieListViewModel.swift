//
//  PopularMovieViewModel.swift
//  PopularMovies
//
//  Created by Tifo Audi Alif Putra on 11/08/21.
//

import Foundation

protocol PopularMovieListViewModel: AnyObject {
    //MARK: - Computed property
    var movies: [Movie] { set get }
    var onFetchMovieSucceed: (() -> Void)? { set get }
    var onFetchMovieFailure: ((Error) -> Void)? { set get }
    func fetchMovie(page: Int,loader: Bool,pagination: Bool)
    func fetchMovieDetail(path: String)
    //
    var hideLoader: Bool { set get }
    var currentPage: Int { set get }
    var totalPages : Int { set get }
    var nextPageAvailable: Bool { set get }
    var isRequestinApi: Bool { set get }
    func showPaginationLoader() -> Bool
}

final class PopularMovieListDefaultViewModel: PopularMovieListViewModel {
   
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    var movies: [Movie] = []
    var movieDetail: MovieDetail?
    var onFetchMovieSucceed: (() -> Void)?
    var onFetchMovieFailure: ((Error) -> Void)?
    //Pagination
    var hideLoader: Bool = false
    var currentPage = 1
    var totalPages = 5
    var nextPageAvailable = true
    var isRequestinApi = false
    func showPaginationLoader() -> Bool {
        return hideLoader ? false : nextPageAvailable
    }
    
    
    func fetchMovieDetail(path: String) {
        let request = MovieDetailRequest(path: path)
        networkService.request(request) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movieDetail = movies
                self?.onFetchMovieSucceed?()
                print("====success response:-\(movies)====")
            case .failure(let error):
                self?.onFetchMovieFailure?(error)
            }
        }
    }
    
    func fetchMovie(page: Int,loader: Bool,pagination: Bool) {
        if pagination {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        let request = PopularMovieRequest(page: page)
        networkService.request(request) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.paginationLogic(page: page, loader: loader, pagination: pagination,response: movies)
            case .failure(let error):
                self?.isRequestinApi = false
                self?.onFetchMovieFailure?(error)
            }
        }
    }
    
    internal func paginationLogic(page: Int,loader: Bool,pagination: Bool,response: MoviesResponse ){
        if response.results?.isEmpty ?? true {
            self.hideLoader = true
            self.movies = []
            self.isRequestinApi = false
            self.onFetchMovieSucceed?()
            return
        }
        self.currentPage = response.page ?? 0
        self.nextPageAvailable = self.currentPage < self.totalPages
        if self.currentPage == 1 {
            self.movies = response.results ?? []
        } else {
            if let results  = response.results {
                self.movies.append(contentsOf: results)
            }
        }
        
        print("====success response:-\(response)====")
        self.currentPage += 1
        self.totalPages = response.totalPages ?? 0
        self.isRequestinApi = false
        self.onFetchMovieSucceed?()
    }
}
