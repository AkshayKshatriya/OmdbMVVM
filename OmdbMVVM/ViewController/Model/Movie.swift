//
//  Movie.swift
//  OmdbMVVM
//
//  Created by Akshay  on 08/10/24.
//

import Foundation

struct MovieResponse: Decodable {
    let search: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}

struct Movie: Decodable {
    
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case imdbID = "imdbID"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
    }
}
