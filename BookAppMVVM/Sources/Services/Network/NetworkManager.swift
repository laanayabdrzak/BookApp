//
//  NetworkManager.swift
//  BookAppMVVM
//
//  Created by LAANAYA Abderrazak on 11/7/2023.
//

import Foundation
import Combine

enum NetworkError: Error, Equatable {
    case bodyInGet
    case invalidURL
    case noInternet
    case invalidResponse(Data?, URLResponse?)
    case accessForbidden
    case unknown
    case httpError(Int)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

class NetworkManager<T: URLSessionProtocol> {
    public let session: T
    
    public required init(session: T) {
        self.session = session
    }
    
    public func fetch(url: URL, method: HTTPMethod, headers: [String : String] = [:], token: String? = nil, data: [String: Any]? = nil) -> AnyPublisher<Data, NetworkError> {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let bearerToken = token {
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        }
        if let data = data {
            var serializedData: Data?
            do {
                serializedData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            } catch {
                return Fail(error: NetworkError.bodyInGet)
                    .eraseToAnyPublisher()
            }
            request.httpBody = serializedData
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unknown }
            .flatMap { data, response -> AnyPublisher<Data, NetworkError> in
                if let response = response as? HTTPURLResponse {
                    /// successful responses
                    if (200..<300).contains(response.statusCode) {
                        return Just(data)
                            .mapError {_ in .unknown }
                            .eraseToAnyPublisher()
                    } else {
                        return Fail(error: NetworkError.httpError(response.statusCode))
                            .eraseToAnyPublisher()
                    }
                }
                return Fail(error: NetworkError.httpError( (response as? HTTPURLResponse)?.statusCode ?? 0 ))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

extension NetworkManager: NetworkManagerProtocol {}
