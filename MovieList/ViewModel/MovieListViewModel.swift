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
    func gamesListDownloadFinished()
}

// MARK: - HomeViewModel Protocol
protocol MovieListViewModelProtocol: AnyObject {
    var allMovies: [Movies] { get set }
    var delegate: MovieListViewModelDelegate? { get set }
}
// MARK: - MovieListViewModel Class
final class MovieListViewModel {
    var allMovies: [Movies] = []
    var images : [UIImageView] = []
    var imageView = UIImageView()
    var imageUrl = ""
    var service : MovieServiceProtocol
    
    weak var delegate: MovieListViewModelDelegate?

    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }
}

//MARK: - Fetch Movies Call
extension MovieListViewModel : MovieListViewModelProtocol {
    func fetchMovies() {
        service.fetchMovies() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.allMovies = movies.Search ?? []
                DispatchQueue.main.async {
                    self.delegate?.gamesListDownloadFinished()
                }

               // for i in 0...(self.allMovies.count) - 1 {
               //     downloadImage(imageUrl: self.allMovies[i].Poster ?? "")
               // }
               //
            case .failure(let error):
                print("FetchGames Error: \(error)")
            }
        }
    }

    func downloadImage(imageUrl : String){
        if imageUrl != "" {
            service.downloadImage(from: URL.init(string: imageUrl)!) { [weak self] (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                            self?.imageView.image = UIImage.init(data: data)
                            self?.delegate?.gamesListDownloadFinished()
                            //self?.images.append(self?.imageView ?? UIImageView())
                       // if self?.allMovies.count == self?.images.count {
                       //     for i in 0...(self?.allMovies.count ?? 0) - 1 {
                       //         self?.allMovies[i].imageData = self?.images[i].image
                       //     }
                       //     self?.delegate?.gamesListDownloadFinished()
                       // }
                    }
                }
            }
        }
    }
}
