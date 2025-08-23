//
//  Playlist.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 23/08/2025.
//

import Foundation

struct Playlist: Codable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    
    
    // MARK: - Properties
    
    let id: Int
    let name: String
    let description: String?
    let createdAt: Date
    let updatedAt: Date
}
