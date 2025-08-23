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
    
    
    
    // MARK: - Construction
    
    init() throws {
        let host = ProcessInfo.processInfo.environment["FINCH_HOST"]
        if host == nil, let data = try? String(contentsOfFile: ".env", encoding: .utf8) {
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
        
        if let host = ProcessInfo.processInfo.environment["FINCH_HOST"] {
            if let url = URL(string: host) {
                self.host = url
            } else {
                throw ServerError.invalidHostEnvironmentVariable
            }
        } else {
            throw ServerError.missingHostEnvironmentVariable
        }
    }
}
