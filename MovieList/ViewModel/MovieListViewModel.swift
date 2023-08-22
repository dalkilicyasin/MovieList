//
//  MovieListViewModel.swift
//  MovieList
//
//  Created by Yasin Dalkilic on 28.07.2023.
//

import Foundation
import UIKit

// MARK: - HomeViewModel Delegate
protocol MovieListViewModelDelegate: AnyObject {
    func moviesListDownloadFinished()
}

// MARK: - MovieListViewModel Class
final class MovieListViewModel {
    var allMovies: [Movies] = []
    var comedyMovies : [Movies] = []
    var imageView = UIImageView()
    var service : MovieServiceProtocol
    
    weak var delegate: MovieListViewModelDelegate?

    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }
}

//MARK: - Fetch Movies Call
extension MovieListViewModel  {
    func fetchMovies() {
        service.fetchMovies() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.comedyMovies = movies.Search ?? []
                DispatchQueue.main.async {
                    self.delegate?.moviesListDownloadFinished()
                }

            case .failure(let error):
                print("FetchMovies Error: \(error)")
            }
        }
    }
    
    func searchMovies(searchText : String?){
        service.searchMovies(searchText: searchText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.allMovies = movies.Search ?? []
                DispatchQueue.main.async {
                    self.delegate?.moviesListDownloadFinished()
                }

            case .failure(let error):
                print("FetchMovies Error: \(error)")
            }
        }
    }
}
