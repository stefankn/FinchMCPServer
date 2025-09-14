//
//  Track.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 14/09/2025.
//

import Foundation

struct Track: Codable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case artist
        case title
        case trackNumber = "track"
        case disc
    }
    
    
    
    // MARK: - Properties
    
    let id: Int
    let artist: String
    let title: String
    let trackNumber: Int?
    let disc: Int?
}
