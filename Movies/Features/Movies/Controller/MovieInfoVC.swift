//
//  MovieInfoVC.swift
//  Movies
//
//  Created by MACM72 on 04/12/25.
//

import UIKit
import Combine
import SwiftUI

final class MovieInfoVC: UIViewController {
    
    private let movieId: Int?
    
    let vm = MoviesVM()
    private let loader = LoadingView()
    private let contentView = MovieInfoContentView()
    
    private let header: Header
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(movieId: Int?, title: String) {
        self.header = Header(title: title)
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.showBackButton = true
        setUpView()
        setConstraints()
        bindViewModel()
        
        Task {
            await vm.loadMovieDetail(id: movieId!)
        }
    }
}

extension MovieInfoVC {
    
    private func setUpView(){
        view.backgroundColor = UIColor(named: "Background")
        view.addSubview(header)
        view.addSubview(loader)
        view.addSubview(contentView)
        
        contentView.isHidden = true   // Start hidden until data loads
    }
    
    private func setConstraints() {
        
        header.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            // Header
            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            header.topAnchor.constraint(equalTo: view.topAnchor),
            
            // Loader
            loader.topAnchor.constraint(equalTo: header.bottomAnchor),
            loader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loader.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content (movie details)
            contentView.topAnchor.constraint(equalTo: header.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
        ])
    }
    
    
    // MARK: - Binding (Combine)
    private func bindViewModel() {
        
        // Loader binding
        vm.$isDetailLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                
                if isLoading {
                    self.loader.start()
                    self.contentView.isHidden = true
                } else {
                    self.loader.stop()
                    self.contentView.isHidden = false
                }
            }
            .store(in: &cancellables)
        
        
        // Movie detail binding
        vm.$movieDetail
            .compactMap { $0 }   // Only proceed when data arrives
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movie in
                self?.contentView.configure(with: movie)
            }
            .store(in: &cancellables)
        
        
        // Back button
        header.backButtonAction = { [weak self] in
            guard let self else { return }
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true)
            }
        }
    }
}



#if DEBUG

struct MovieInfoVC_Preview: PreviewProvider {
    static var previews: some View {
        MovieInfoVCRepresentable()
            .ignoresSafeArea()
            .previewDevice("iPhone 15")
    }
}

struct MovieInfoVCRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> MovieInfoVC {
        // Provide dummy movieId + title for preview
        return MovieInfoVC(movieId: 12345, title: "Movie Title")
    }

    func updateUIViewController(_ uiViewController: MovieInfoVC, context: Context) {
        // No update needed
    }
}

#endif
