//
//  ItemsResponse.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 29/08/2025.
//

import Foundation

struct ItemsResponse<Item: Decodable>: Decodable, Sendable where Item: Sendable {
    
    // MARK: - Properties
    
    let items: [Item]
}
