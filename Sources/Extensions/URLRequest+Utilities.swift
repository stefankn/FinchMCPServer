//
//  URLRequest+Utilities.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 23/08/2025.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLRequest {
    
    // MARK: - Types
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    
    
    // MARK: - Construction
    
    init(_ method: HTTPMethod, url: URL) {
        self.init(url: url)
        httpMethod = method.rawValue
    }
}
