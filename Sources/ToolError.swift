//
//  ToolError.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 24/08/2025.
//

import Foundation
import FinchProtocol

enum ToolError: Error {
    case invalidArgument
    case invalidResponse(ResponseMessage)
    case failure(Error)
    case unknownTool(String)
    
    
    
    // MARK: - Properties
    
    var localizedDescription: String {
        switch self {
        case .invalidArgument:
            return "Invalid argument provided."
        case .invalidResponse:
            return "Invalid response received from the tool."
        case .failure(let underlyingError):
            return "An underlying error occurred: \(underlyingError)"
        case .unknownTool(let toolName):
            return "Unknown tool: \(toolName)"
        }
    }
}
