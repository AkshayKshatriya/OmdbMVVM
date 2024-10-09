//
//  HttpClient.swift
//  OmdbMVVM
//
//  Created by Akshay  on 08/10/24.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badUrl
}

class HttpClient {
    func fetchMovies(_ searchKeyword: String) -> AnyPublisher<[Movie], Error> {
        guard let encodedSearch = searchKeyword.urlEncoded,
              let url = URL(string: "https://www.omdbapi.com/?apikey=1e146628&s=\(encodedSearch)&page=2") else {
            return Fail(error: NetworkError.badUrl).eraseToAnyPublisher()
        }
        
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.search)
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<[Movie], Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

