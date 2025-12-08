//import Foundation
//
//final class ApiService {
//    
//    static let shared = ApiService()
//    private init() {}
//    
//    private(set) var api_key = "14bc774791d9d20b3a138bb6e26e2579"
//    
//    // MARK: - Generic GET Request
//    func get<T: Decodable>(
//        baseURL: String = "https://api.themoviedb.org/3",
//        endPoint: String,
//        query: [String: String] = [:],
//        headers: [String: String] = [:]
//    ) async throws -> T {
//        
//        let urlString = baseURL + endPoint
//        
//        guard var components = URLComponents(string: urlString) else {
//            throw URLError(.badURL)
//        }
//        
//        if !query.isEmpty {
//            components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
//        }
//        
//        guard let url = components.url else {
//            throw URLError(.badURL)
//        }
//        
//        print("Final URL → \(url)")
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        headers.forEach { key, value in
//            request.setValue(value, forHTTPHeaderField: key)
//        }
//        
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        guard let http = response as? HTTPURLResponse else {
//            throw URLError(.badServerResponse)
//        }
//        
//        guard (200...299).contains(http.statusCode) else {
//            throw URLError(.badServerResponse)
//        }
//        
//        let decoder = JSONDecoder()
//        return try decoder.decode(T.self, from: data)
//    }
//}

import Foundation
import Alamofire

final class ApiService {
    
    static let shared = ApiService()
    private init() {}
    
    private(set) var api_key = "14bc774791d9d20b3a138bb6e26e2579"
    
    // MARK: - Generic GET Request (Alamofire)
    func get<T: Decodable>(
        baseURL: String = "https://api.themoviedb.org/3",
        endPoint: String,
        query: [String: String] = [:],
        headers: [String: String] = [:]
    ) async throws -> T {
        
        let urlString = baseURL + endPoint
        
        print("Final URL → \(urlString)")
        
        let afHeaders = HTTPHeaders(headers)
        
        return try await withCheckedThrowingContinuation { continuation in
            
            AF.request(
                urlString,
                method: .get,
                parameters: query,
                headers: afHeaders
            )
            .validate(statusCode: 200...299)
            .responseDecodable(of: T.self) { response in
                
                switch response.result {
                case .success(let decoded):
                    continuation.resume(returning: decoded)
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
