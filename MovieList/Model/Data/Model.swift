//
//  Model.swift
//  MovieList
//
//  Created by Yasin Dalkilic on 29.07.2023.
//

import Foundation
import UIKit

// MARK: - Models

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



public struct MovieDetail: Decodable {
    public let name: String?
    public let released: String?
    public let backgroundImage:String?
    public let id: Int32?
    public let rating: Double?
    public let metacritic: Int?
    public let description: String?

    enum CodingKeys: String,CodingKey {
        case name
        case released
        case backgroundImage = "background_image"
        case id
        case rating
        case metacritic
        case description = "description_raw"
    }
}

