//
//  MovieListDetailViewModel.swift
//  MovieList
//
//  Created by Yasin Dalkilic on 1.08.2023.
//

import Foundation
import UIKit


// MARK: - HomeViewModel Delegate
protocol MovieListDetailViewModelDelegate: AnyObject {
    func moviesListDownloadFinished()
}

// MARK: - MovieListViewModel Class
final class MovieListDetailViewModel {
    var movieDetail = MovieDetail(Title: "", Year: "", Rated: "", Released: "", Runtime: "", Genre: "", Director: "", Writer: "", Actors: "", Plot: "", Language: "", Country: "", Awards: "", Poster: "", Metascore: "", imdbRating: "", imdbVotes: "", DVD: "", BoxOffice: "")
    var imageView = UIImageView()
    var service : MovieServiceProtocol

    weak var delegate: MovieListDetailViewModelDelegate?

    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }
}

extension MovieListDetailViewModel {

    func fetchMoviewDetail(imdbId : String) {
        service.fetchMovieDetails(with: imdbId) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieDetail):
                self.movieDetail = movieDetail
                DispatchQueue.main.async {
                    self.delegate?.moviesListDownloadFinished()
                }

            case .failure(let error):
                print("FetchMovies Error: \(error)")
            }
        }
    }
}
