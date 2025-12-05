//
//  MovieInfoVC.swift
//  Movies
//
//  Created by MACM72 on 04/12/25.
//

import UIKit
import SwiftUI

final class MovieInfoVC: UIViewController {
    
    private let movieId: Int?
    
    let vm = MoviesVM()
    private let loader = LoadingView()
    private let contentView = MovieInfoContentView()
    
    private let header: Header

    init(movieId: Int?, title: String) {
        self.header = Header(title: title)
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        header.showBackButton = true
        
        setUpView()
        setConstraints()
        bindViewModel()
        
        Task {
           await self.vm.loadMovieDetail(movieId: movieId!)
        }
        
    }
}



extension MovieInfoVC {
    
    private func setUpView(){
        view.backgroundColor = UIColor(named: "Background")
        view.addSubview(header)
        view.addSubview(loader)
        view.addSubview(contentView)

    }
    
    private func setConstraints() {
        
        header.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            //header
            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            header.topAnchor.constraint(equalTo: view.topAnchor),
            
            // loader
            loader.topAnchor.constraint(equalTo: header.bottomAnchor , constant: 0),
            loader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loader.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: header.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
        ])
    }
    
    private func bindViewModel() {
        vm.onDetailLoadingChanged = { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.loader.start()
                contentView.isHidden = true
               
            } else {
                self.loader.stop()
                contentView.isHidden = false
            }
        }
        
        vm.onMovieLoaded = { [weak self] movie in
            print("onMovieLoaded")
            self?.contentView.configure(with: movie)
        }
        
        header.backButtonAction = { [weak self] in
            guard let self = self else { return }
        
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true)            // ← For modal presentation
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
