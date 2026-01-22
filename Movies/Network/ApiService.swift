import Foundation
import Alamofire

final class ApiService {
    
    static let shared = ApiService()
    private init() {}
    
    private(set) var api_key = "14bc774791d9d20b3a138bb6e26e2579"

    func get<T: Decodable>(
        baseURL: String = "https://api.themoviedb.org/3",
        endPoint: String,
        query: [String: String] = [:],
        headers: [String: String] = [:]
    ) async throws -> T {
        print("Strat")
        let connected = await NetworkReachability.shared.waitForConnection()
        guard connected else { throw NetworkError.noInternet }
        print("NetworkReachability")


        let urlString = baseURL + endPoint
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
                print("APISERVUICE REsponse :\(response)")
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
