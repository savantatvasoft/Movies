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
    private var cancellables = Set<AnyCancellable>()
    
    
    private lazy var tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.backgroundColor = UIColor(named: "Background")
        table.dataSource = self
        table.delegate = self
        table.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        return table
    }()
    
    // Reuse LoadingView for footer
    private lazy var footerLoader: LoadingView = {
        let view = LoadingView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setUpView()
        setConstraints()
       
    }
}



extension MoviesVC {
    
    private func setUpView(){
        view.backgroundColor = UIColor(named: "Background")
        
        view.addSubview(header)
        view.addSubview(tableView)
        view.addSubview(loader)
        view.bringSubviewToFront(loader)
    }
    
    private func setConstraints() {
        
        header.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            header.topAnchor.constraint(equalTo: view.topAnchor),
            
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor , constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10 ),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loader.topAnchor.constraint(equalTo: header.bottomAnchor , constant: 0),
            loader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loader.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
    private func bindViewModel() {
        
        // Movies list change
        vm.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        //.store(in:) is triggered immediately when you create the subscription.
        //Keep this subscription alive until this VC is destroyed.Without .store(in:)
//        Your subscription will die immediately..store runs only once (when creating subscription).
        
        // Initial Loader
        vm.$isInitialLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                self.tableView.isHidden = isLoading
                isLoading ? self.loader.start() : self.loader.stop()
            }
            .store(in: &cancellables)
        
        // Pagination Loader
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
}



extension MoviesVC : UITableViewDataSource , UITableViewDelegate {
    
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
        let detailVC = MovieInfoVC(movieId: movie.id,title: movie.title)
        navigationController?.pushViewController(detailVC, animated: true)
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
