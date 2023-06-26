//
//  PopularMovieListViewController.swift
//  PopularMovies
//
//  Created by Tifo Audi Alif Putra on 11/08/21.
//

import UIKit

final class PopularMovieListViewController: UITableViewController {
    
    private let viewModel: PopularMovieListViewModel
    
    init(viewModel: PopularMovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchMovies(page: self.viewModel.currentPage)
        bindViewModelEvent()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 120.0
        tableView.register(
            PopularMovieCell.self,
            forCellReuseIdentifier: PopularMovieCell.cellIdentifier
        )
        tableView.register(UINib(nibName: "LoaderCell", bundle: Bundle.main), forCellReuseIdentifier: "LoaderCell")
    }
    
    private func fetchMovies(page: Int = 1,loader: Bool = false,pagination: Bool = true) {
        viewModel.fetchMovie(page: page,loader: loader,pagination: pagination)
    }
    
    private func bindViewModelEvent() {
        viewModel.onFetchMovieSucceed = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onFetchMovieFailure = { error in
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count + (self.viewModel.showPaginationLoader() ?  1 : 0)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == (viewModel.movies.endIndex) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoaderCell", for: indexPath)
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularMovieCell.cellIdentifier, for: indexPath) as? PopularMovieCell else {
                return UITableViewCell()
            }
            
            let movie = viewModel.movies[indexPath.row]
            cell.bindViewWith(
                viewModel: PopularMovieDefaultViewModel(
                    movie: movie
                )
            )
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell as? LoaderCell != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                self.fetchMovies(page: self.viewModel.currentPage,loader: false,pagination: true)
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = self.viewModel.movies[indexPath.item].id{
            self.viewModel.fetchMovieDetail(path: String(id))
        }
    }
}

