//
//  HTTPURLResponse+Utilities.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 23/08/2025.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension HTTPURLResponse {
    
    // MARK: - Properties
    
    var status: HTTPStatus {
        HTTPStatus(statusCode)
    }
}
