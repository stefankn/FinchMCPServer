//
//  ServerError.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 23/08/2025.
//

import Foundation

enum ServerError: Error {
    case missingHostEnvironmentVariable
    case invalidHostEnvironmentVariable
}
