
import Foundation
import Combine

class MoviesVM {
    
    // MARK: - Published States
    @Published private(set) var movies: [Movies] = []
    @Published private(set) var isInitialLoading: Bool = true
    @Published private(set) var isPaginationLoading: Bool = false
    @Published private(set) var movieDetail: MovieDetail?
    @Published private(set) var isDetailLoading: Bool = false
    @Published private(set) var networkError: String?

    // MARK: - Pagination
    private var currentPage = 0
    private var totalPages = 1
    private var canLoadMore: Bool { currentPage < totalPages }

    // MARK: Research on this
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
        loadInitialMovies()
    }

    private func checkInternetOrFail(isInitialLoad: Bool) async -> Bool {
        guard NetworkReachability.shared.isConnected else {
            await MainActor.run {
                if isInitialLoad {
                    isInitialLoading = false
                } else {
                    isPaginationLoading = false
                }
                isDetailLoading = false
                networkError = "No internet connection. Please check your network."
            }
            return false
        }
        return true
    }


    func loadInitialMovies() {
        Task {
            await fetchMovies(page: 1, isInitialLoad: true)
        }
    }
    
    // MARK: - Load Next Page
    func loadMore() {
        guard canLoadMore, !isPaginationLoading else { return }
        Task { await fetchMovies(page: currentPage + 1, isInitialLoad: false) }
    }
    
    
    // MARK: - API Core
    private func fetchMovies(page: Int, isInitialLoad: Bool) async {
        
        await MainActor.run {
            networkError = nil
            if isInitialLoad { isInitialLoading = true }
            else { isPaginationLoading = true }
        }

//        guard await checkInternetOrFail(isInitialLoad: isInitialLoad) else { return }

        do {
            let response: MoviesResponse = try await ApiService.shared.get(
                endPoint: "/discover/movie",
                query: [
                    "api_key": ApiService.shared.api_key,
                    "page": "\(page)"
                ]
            )
            
            await MainActor.run {
                if isInitialLoad {
                    movies = response.results
                } else {
                    movies.append(contentsOf: response.results)
                }
                
                currentPage = response.page
                totalPages = response.totalPages
                
                if isInitialLoad { isInitialLoading = false }
                else { isPaginationLoading = false }
            }
            
        } catch {
            await MainActor.run {
                if isInitialLoad { isInitialLoading = false }
                else { isPaginationLoading = false }
            }
        }
    }
    
    
    // MARK: - Movie Detail
    func loadMovieDetail(id: Int) async {
        Task {
            await MainActor.run {
                networkError = nil
                isDetailLoading = true
                movieDetail = nil
            }
        }

        guard await checkInternetOrFail(isInitialLoad: isDetailLoading) else { return }

        Task {
            do {
                let response: MovieDetail = try await ApiService.shared.get(
                    endPoint: "/movie/\(id)",
                    query: ["api_key": ApiService.shared.api_key]
                )
                print("response :\(response)")
                await MainActor.run {
                    movieDetail = response
                    isDetailLoading = false
                }
            } catch {
                print("error :\(error)")
                await MainActor.run { isDetailLoading = false }
            }
        }
    }
    
    // MARK: - Search Movie
    func searchMovies(moviewName movie: String) async {
        Task {
            await MainActor.run {
                networkError = nil
                isInitialLoading = true
            }
        }

        guard await checkInternetOrFail(isInitialLoad: true) else { return }

        Task {
            do {
                let response: MoviesResponse = try await ApiService.shared.get(
                    endPoint: "/search/movie",
                    query: [
                        "api_key": ApiService.shared.api_key,
                        "query":"\(movie)"
                    ]
                )
                
                await MainActor.run {
                    movies = response.results
                    currentPage = response.page
                    totalPages = response.totalPages
                    
                   isInitialLoading = false
                }
            } catch {
                await MainActor.run { isInitialLoading = false }
            }
        }
        
    }
}
