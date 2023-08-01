//
//  Model.swift
//  MovieList
//
//  Created by Yasin Dalkilic on 29.07.2023.
//

import Foundation
import UIKit

// MARK: - Movies Model
public struct Movies: Decodable {
    public let Title: String?
    public let Year: String?
    public let imdbID: String?
    public let `Type`: String?
    public let Poster: String?
    public var imageData : UIImage? = nil

    public init(Title: String?, Year: String?, imdbID: String?, Type: String?, Poster: String?, imageData : UIImage?) {
        self.Title = Title
        self.Year = Year
        self.imdbID = imdbID
        self.`Type` = Type
        self.Poster = Poster
        self.imageData = imageData
    }

    enum CodingKeys : String, CodingKey {
        case Title = "Title"
        case Year =  "Year"
        case imdbID = "imdbID"
        case `Type` = "`Type`"
        case Poster = "Poster"
    }
}

// MARK: - MovieDetail Model
public struct MovieDetail: Decodable {
    public let Title: String?
    public let Year: String?
    public let Rated:String?
    public let Released: String?
    public let Runtime: String?
    public let Genre: String?
    public let Director: String?
    public let Writer: String?
    public let Actors: String?
    public let Plot:String?
    public let Language: String?
    public let Country: String?
    public let Awards: String?
    public let Poster: String?
    public let Metascore: String?
    public let imdbRating: String?
    public let imdbVotes: String?
    public let DVD: String?
    public let BoxOffice: String?
}

