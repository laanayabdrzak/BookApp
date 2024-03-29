//
//  AnyNetworkManager.swift
//  BookAppMVVM
//
//  Created by LAANAYA Abderrazak on 11/7/2023.
//

import Foundation
import Combine


class AnyNetworkManager<U: URLSessionProtocol>: NetworkManagerProtocol {
    public let session: U
    
    let fetchClosure: (URL, HTTPMethod, [String : String], String?, [String : Any]?) -> AnyPublisher<Data, NetworkError>
    
    public init<T: NetworkManagerProtocol>(manager: T) {
        fetchClosure = manager.fetch
        session = manager.session as! U
    }
    
    public func fetch(url: URL, method: HTTPMethod, headers: [String : String] = [:], token: String? = nil, data: [String: Any]? = nil) -> AnyPublisher<Data, NetworkError> {
        fetchClosure(url, method, headers, token, data)
    }
}
