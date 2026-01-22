//
//  NetworkReachability.swift
//  Movies
//
//  Created by MACM72 on 21/01/26.
//

import Foundation
import Network

enum NetworkError: LocalizedError {
    case noInternet
    case timeout
    case serverError
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "No internet connection."
        case .timeout:
            return "Request timed out."
        case .serverError:
            return "Server error. Try again later."
        case .unauthorized:
            return "Session expired. Please login again."
        }
    }
}


final class NetworkReachability {

    static let shared = NetworkReachability()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkReachability")

    private(set) var isConnected: Bool = false

    private var didCheckInitialPath = false
    private var initialPathContinuation: CheckedContinuation<Bool, Never>?

    private init() {
        startMonitoring()
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            self.isConnected = (path.status == .satisfied)

            if !self.didCheckInitialPath {
                self.didCheckInitialPath = true
                self.initialPathContinuation?.resume(returning: self.isConnected)
                self.initialPathContinuation = nil
            }
        }
        monitor.start(queue: queue)
    }

    // Async function to wait for first network status
    func waitForConnection() async -> Bool {
        if didCheckInitialPath {
            return isConnected
        }
        return await withCheckedContinuation { continuation in
            self.initialPathContinuation = continuation
        }
    }
}

