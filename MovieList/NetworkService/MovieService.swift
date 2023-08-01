//
//  MovieService.swift
//  MovieList
//
//  Created by Yasin Dalkilic on 29.07.2023.
//

import Foundation
import UIKit

enum Constants: String {
    case baseURL = "https://www.omdbapi.com"
    case APIKey = "21aa9af8"
}

// MARK: Protocol
public protocol MovieServiceProtocol: AnyObject {
    func fetchMovies(completion: @escaping (Result<MovieList, Error>) -> Void)
    func fetchMovieDetails(with imdbId: String, completion: @escaping (Result<MovieDetail, Error>) -> Void)
    func downloadImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ())
    func searchMovies(searchText : String?, completion: @escaping (Result<MovieList, Error>) -> Void)
}

public class MovieService: MovieServiceProtocol {

    // MARK: Searcg Movies
    public func searchMovies(searchText: String?, completion: @escaping (Result<MovieList, Error>) -> Void) {
        let urlString = Constants.baseURL.rawValue + "/?s=\(searchText ?? "")&apikey=" + Constants.APIKey.rawValue

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("**** GEÇİCİ BİR HATA OLUŞTU: \(error.localizedDescription) ******")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("Invalid Data")
                return
            }

            let decoder = JSONDecoder()

            do {
                let response = try decoder.decode(MovieList.self, from: data)

                completion(.success(response))

            } catch {
                print("********** JSON DECODE ERROR *******")
                completion(.failure(error))
            }
        }

        task.resume()
    }

    public init() {}

    // MARK: Fetch Movies
    public func fetchMovies(completion: @escaping (Result<MovieList, Error>) -> Void) {
        let urlString = Constants.baseURL.rawValue + "/?s=comedy&apikey=" + Constants.APIKey.rawValue

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("**** GEÇİCİ BİR HATA OLUŞTU: \(error.localizedDescription) ******")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("Invalid Data")
                return
            }

            let decoder = JSONDecoder()

            do {
                let response = try decoder.decode(MovieList.self, from: data)

                completion(.success(response))

            } catch {
                print("********** JSON DECODE ERROR *******")
                completion(.failure(error))
            }
        }

        task.resume()
    }

    // MARK: Download Image
    public func downloadImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    // MARK: Fetch Movie Details
    public func fetchMovieDetails(with imdbId: String, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let urlString = Constants.baseURL.rawValue + "/?i=\(imdbId)&apikey=" + Constants.APIKey.rawValue

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("**** GEÇİCİ BİR HATA OLUŞTU: \(error.localizedDescription) ******")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("Invalid Data")
                return
            }

            let decoder = JSONDecoder()

            do {
                let response = try decoder.decode(MovieDetail.self, from: data)
                completion(.success(response))
            } catch {
                print("********** JSON DECODE ERROR *******")
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
