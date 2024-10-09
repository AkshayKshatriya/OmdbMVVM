//
//  MovieListViewModel.swift
//  OmdbMVVM
//
//  Created by Akshay  on 08/10/24.
//

import Foundation
import Combine

class MovieListViewModel {
    private(set) var movies: [Movie] = []
    @Published var loadinComplete = false
    private var searchSubject = CurrentValueSubject<String, Never>("")
    
    private let httpClient: HttpClient
    private var cancellabel: Set<AnyCancellable> = []
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
        setupSearchPublisher()
    }
    
    private func setupSearchPublisher() {
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                print("setupSearchPublisher = \(searchText)")
                self?.loadMovie(searchText)
            }.store(in: &cancellabel)
    }
    
    func setSearchText(_ searchText: String) {
        print("setSearchText = \(searchText)")
        searchSubject.send(searchText)
    }
    
    func loadMovie(_ searchKeyword: String) {
        httpClient.fetchMovies(searchKeyword)
            .sink { completion in
                switch completion {
                case .finished:
                    self.loadinComplete = true
                    print("finished")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { movies in
                self.movies = movies
            }.store(in: &cancellabel)

    }
}
