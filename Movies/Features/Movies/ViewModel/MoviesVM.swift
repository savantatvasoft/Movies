
import Foundation

class MoviesVM {
    
    private(set) var movies: [Movies] = []
    private(set) var movieDetail: MovieDetail?
    private var currentPage = 0
    private var totalPages = 1
    private var canLoadMore: Bool {
        return currentPage < totalPages
    }
    
    private(set) var isInitialLoading = true {
        didSet {
            // Trigger callBAck autoomatic for start loader
            // Becasue if you this trigger callBack in init it does not work
            // beacause in  viewcontroll in viewDidLoad trigger after init of VM so this will set that nil
            onInitialLoadingChanged?(isInitialLoading)
        }
    }
    
    private(set) var isPaginationLoading = false {
        didSet {
            onPaginationLoadingChanged?(isPaginationLoading)
        }
    }
    
    var onInitialLoadingChanged: ((Bool) -> Void)? {
        didSet {
            onInitialLoadingChanged?(isInitialLoading)
        }
    }
    
    var onPaginationLoadingChanged: ((Bool) -> Void)? {
        didSet {
            onPaginationLoadingChanged?(isPaginationLoading)
        }
    }
    
    var onDetailLoadingChanged: ((Bool) -> Void)? {
        didSet {
            onDetailLoadingChanged?(isDetailLoading)
        }
    }
    
    private(set) var isDetailLoading = false {
        didSet {
            onDetailLoadingChanged?(isDetailLoading)
        }
    }
    
    var onMovieLoaded: ((MovieDetail) -> Void)?
    
    init() {
        Task {
            await loadInitialMovies()
        }
    }
    
    // Load first page
    private func loadInitialMovies() async {
        await fetchMovies(page: 1, isInitialLoad: true)
    }
    
    // Load next page
    func loadMore() {
        guard canLoadMore && !isPaginationLoading else {
            return
        }
        
        Task {
            await fetchMovies(page: currentPage + 1, isInitialLoad: false)
        }
    }
    
    
    private func fetchMovies(page: Int, isInitialLoad: Bool) async {
    
        await MainActor.run {
            if isInitialLoad {
                self.isInitialLoading = true
            } else {
                self.isPaginationLoading = true
            }
        }
        
        do {
            let response: MoviesResponse = try await ApiService.shared.get(
                endPoint: "/discover/movie",
                query: [
                    "api_key": ApiService.shared.api_key,
                    "page": String(page)
                ]
            )
            
            //You cannot await inside a DispatchQueue.main.async { ... } block.
//            try await Task.sleep(nanoseconds: 5_000_000_000)
            
            await MainActor.run {
                if isInitialLoad {
                    self.movies = response.results
                } else {
                    self.movies.append(contentsOf: response.results)
                }
                
                self.currentPage = response.page
                self.totalPages = response.totalPages
                
                if isInitialLoad {
                    self.isInitialLoading = false
                } else {
                    self.isPaginationLoading = false
                }
            }
            
        } catch {
            print("Error loading movies: \(error.localizedDescription)")
            
            await MainActor.run {
                if isInitialLoad {
                    self.isInitialLoading = false
                } else {
                    self.isPaginationLoading = false
                }
            }
        }
    }
    
    
    func loadMovieDetail(movieId: Int) async {
        await MainActor.run {
            self.isDetailLoading = true
            self.movieDetail = nil // Clear previous detail
        }
        
        do {
            
            let detail: MovieDetail = try await ApiService.shared.get(
                endPoint: "/movie/\(movieId)",
                query: [
                    "api_key": ApiService.shared.api_key
                ]
            )
            print("movie details \(detail)")
            await MainActor.run {
                self.movieDetail = detail
                self.isDetailLoading = false
                self.onMovieLoaded?(detail)
            }
        } catch {
            print("movie details error: \(error)")
            await MainActor.run {
                self.isDetailLoading = false

            }
        }
    }
    
    
    
}
