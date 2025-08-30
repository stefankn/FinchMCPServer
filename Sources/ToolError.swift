//
//  ToolError.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 24/08/2025.
//

import Foundation
import FinchProtocol

enum ToolError: Error {
    case invalidResponse(ResponseMessage)
    
    
    
    // MARK: - Properties
    
    var localizedDescription: String {
        switch self {
        case .invalidResponse:
            return "Invalid response received from the tool."
        }
    }
}
