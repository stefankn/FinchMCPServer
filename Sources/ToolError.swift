//
//  ToolError.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 24/08/2025.
//

import Foundation

enum ToolError: Error {
    case invalidArgument
    case invalidResponse
    case failure(Error)
    case unknownTool(String)
}
