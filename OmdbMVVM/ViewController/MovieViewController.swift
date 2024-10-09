//
//  MovieViewController.swift
//  OmdbMVVM
//
//  Created by Akshay  on 08/10/24.
//

import Foundation
import UIKit
import Combine
import SwiftUI

class MoviewViewController: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var movieTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private let viewModel: MovieListViewModel
    private var cancellabel: Set<AnyCancellable> = []
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.$loadinComplete
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isCompleted in
                if isCompleted {
                    self?.movieTableView.reloadData()
                }
            }
            .store(in: &cancellabel)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        movieTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MoviewTableViewCell")
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(movieTableView)
        searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

extension MoviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviewTableViewCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.movies[indexPath.row].title
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension MoviewViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.setSearchText(searchText)
    }
    
}

struct MoviewViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MoviewViewController
    
    func makeUIViewController(context: Context) -> MoviewViewController {
        return MoviewViewController(viewModel: MovieListViewModel(httpClient: HttpClient()))
    }
    
    func updateUIViewController(_ uiViewController: MoviewViewController, context: Context) {
        
    }
}

#Preview {
    MoviewViewControllerRepresentable()
}
