//
//  HTTPStatus.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 23/08/2025.
//

import Foundation

struct HTTPStatus: Equatable {
    
    // MARK: - Constants
    
    static let ok = HTTPStatus(200)
    static let badRequest = HTTPStatus(400)
    static let unauthorized = HTTPStatus(401)
    static let forbidden = HTTPStatus(403)
    static let notFound = HTTPStatus(404)
    static let notAllowed = HTTPStatus(405)
    static let preconditionFailed = HTTPStatus(412)
    
    
    
    // MARK: - Properties
    
    let code: Int
    
    var isSuccess: Bool {
        200 ..< 300 ~= code
    }
    
    var isClientError: Bool {
        400 ..< 500 ~= code
    }
    
    var isServerError: Bool {
        500 ..< 600 ~= code
    }
    
    
    
    // MARK: - Construction
    
    init(_ code: Int) {
        self.code = code
    }
}
