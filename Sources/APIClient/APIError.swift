//
//  APIError.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 23/08/2025.
//

import Foundation

enum APIError: Error {
    case badRequest(String?)
    case failure(HTTPStatus, Data?)
    case notFound
}
