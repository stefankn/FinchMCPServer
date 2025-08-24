//
//  Environment.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 23/08/2025.
//

import Foundation

struct Environment {
    
    // MARK: - Properties
    
    let host: URL
    let finchHost: String
    let finchPort: Int
    
    
    
    // MARK: - Construction
    
    init() throws {
        
        // Read from .env file if available
        if let data = try? String(contentsOfFile: ".env", encoding: .utf8) {
            data
                .components(separatedBy: .newlines)
                .compactMap { line -> (String, String)? in
                    let trimmed = line.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty, !trimmed.hasPrefix("#"), let equalIndex = trimmed.firstIndex(of: "=") else {
                        return nil
                    }
                    
                    let key = String(trimmed[..<equalIndex]).trimmingCharacters(in: .whitespaces)
                    let value = String(trimmed[trimmed.index(after: equalIndex)...])
                        .trimmingCharacters(in: .whitespaces)
                        .trimmingCharacters(in: CharacterSet(charactersIn: "\"'"))
                    
                    return (key, value)
                }
                .forEach { key, value in
                    setenv(key, value, 1)
                }
        }
        
        let apiHost = ProcessInfo.processInfo.environment["FINCH_API_HOST"]
        let finchHost = ProcessInfo.processInfo.environment["FINCH_HOST"]
        let finchPort = ProcessInfo.processInfo.environment["FINCH_PORT"]
        
        if let apiHost {
            if let url = URL(string: apiHost) {
                self.host = url
                self.finchHost = finchHost ?? "host.docker.internal"
                self.finchPort = Int(finchPort ?? "") ?? 8888
            } else {
                throw ServerError.invalidHostEnvironmentVariable
            }
        } else {
            throw ServerError.missingHostEnvironmentVariable
        }
    }
}
