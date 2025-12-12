//
//  MoviesVC.swift
//  Movies
//
//  Created by MACM72 on 03/12/25.
//

import UIKit
import Combine

class MoviesVC: UIViewController {
    
    let vm = MoviesVM()
    private let loader = LoadingView()
    private let header = Header(title: "Movies")
    private let searchBar = SearchBarView()
    private var cancellables = Set<AnyCancellable>()
    
    private var headerTopConstraint: NSLayoutConstraint!
    private var searchBarTopConstraint: NSLayoutConstraint!

   
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.backgroundColor = UIColor(named: "Background")
        table.dataSource = self
        table.delegate = self
        table.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        return table
    }()
    
    private let emptyLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "No Movies Found"
        lbl.textColor = .lightGray
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 18, weight: .medium)
        lbl.isHidden = true
        return lbl
    }()
    
    private lazy var footerLoader: LoadingView = {
        let view = LoadingView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        bindViewModel()
        setUpView()
        setConstraints()
        setupDismissKeyboardGesture()
    }
}

// MARK: - Setup Views & Constraints
extension MoviesVC {
    
    private func setUpView() {
        view.backgroundColor = UIColor(named: "Background")
        
        view.addSubview(header)
        view.addSubview(tableView)
        view.addSubview(loader)
        view.addSubview(emptyLabel)
        
    
        view.addSubview(searchBar)
        
        view.bringSubviewToFront(loader)
        view.bringSubviewToFront(searchBar)
    }
    
    private func setConstraints() {
        header.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        headerTopConstraint = header.topAnchor.constraint(equalTo: view.topAnchor)
        searchBarTopConstraint = searchBar.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 30)
        searchBarTopConstraint.isActive = true
        
        
        NSLayoutConstraint.activate([
            headerTopConstraint,
            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            // Table
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Loader
            loader.topAnchor.constraint(equalTo: header.bottomAnchor),
            loader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loader.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Empty label
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Bind ViewModel
extension MoviesVC {
    
    private func bindViewModel() {
        vm.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                guard let self else { return }
                self.tableView.reloadData()
                self.emptyLabel.isHidden = self.vm.isInitialLoading || !movies.isEmpty
            }
            .store(in: &cancellables)
        
        vm.$isInitialLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                self.tableView.isHidden = isLoading
                isLoading ? self.loader.start() : self.loader.stop()
            }
            .store(in: &cancellables)
        
        vm.$isPaginationLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.footerLoader.start()
                    self.tableView.tableFooterView = self.footerLoader
                } else {
                    self.footerLoader.stop()
                    self.tableView.tableFooterView = nil
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tap.cancelsTouchesInView = false  // IMPORTANT: allows tableView taps to still work
        view.addGestureRecognizer(tap)
    }
    
    @objc private func handleTapOutside() {
        view.endEditing(true)  // hides keyboard
    }


}

// MARK: - TableView DataSource & Delegate
extension MoviesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }

        let movie = vm.movies[indexPath.row]
        cell.configure(with: movie)

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == vm.movies.count - 1 {
            vm.loadMore()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = vm.movies[indexPath.row]
        let detailVC = MovieInfoVC(movieId: movie.id, title: movie.title)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MoviesVC: SearchBarViewDelegate {

    func didStartSearching() {
        headerTopConstraint.constant = -header.frame.height
        searchBarTopConstraint.constant = 50

        UIView.animate(withDuration: 0.3) {
            self.header.alpha = 0
            self.tableView.isHidden = true
            self.view.layoutIfNeeded()
        }

        // Add suggestion view to main view for scrolling
        searchBar.suggestionView.removeFromSuperview()
        view.addSubview(searchBar.suggestionView)
        view.bringSubviewToFront(searchBar.suggestionView)
        
        searchBar.suggestionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.suggestionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4),
            searchBar.suggestionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            searchBar.suggestionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            searchBar.suggestionView.heightAnchor.constraint(equalToConstant: 240)
        ])

        searchBar.suggestionView.showAll()
    }
    
    func didCancelSearching() {
        headerTopConstraint.constant = 0
        searchBarTopConstraint.constant = 30

        UIView.animate(withDuration: 0.3) {
            self.header.alpha = 1
            self.tableView.isHidden = false
            self.view.layoutIfNeeded()
        }

        // Hide suggestion view
        searchBar.suggestionView.isHidden = true
        searchBar.suggestionView.removeFromSuperview()
        vm.loadInitialMovies()
    }

    func didChangeText(_ text: String) {
        if text.isEmpty {
            vm.loadInitialMovies()
        } else {
            vm.searchMovies(moviewName: text)
        }
    }
}


#if DEBUG
import SwiftUI

struct MoviesVC_Preview: PreviewProvider {
    static var previews: some View {
        MoviesVCRepresentable()
            .ignoresSafeArea()
            .previewDevice("iPhone 15")
    }
}

struct MoviesVCRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MoviesVC {
        return MoviesVC()
    }

    func updateUIViewController(_ uiViewController: MoviesVC, context: Context) {
        // no update needed
    }
}
#endif
