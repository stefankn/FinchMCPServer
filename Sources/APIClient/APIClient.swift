//
//  APIClient.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 23/08/2025.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

actor APIClient {

    // MARK: - Types
    
    typealias Parameters = [(name: String, value: CustomStringConvertible)]
    
    
    
    // MARK: - Private Properties
    
    private let environment: Environment
    
    
    
    // MARK: - Construction
    
    init(environment: Environment) {
        self.environment = environment
    }
    
    
    
    // MARK: - Functions
    
    func getPlaylists() async throws -> [Playlist] {
        try await get("/api/v1/playlists")
    }
    
    func searchAlbums(query: String) async throws -> ItemsResponse<Album> {
        try await get("/api/v1/albums", parameters: [("search", query), ("per", 100)])
    }
    
    
    
    // MARK: - Private Functions
    
    private func get<Response: Decodable>(_ path: String, parameters: Parameters? = nil) async throws -> Response {
        try await request(URLRequest(.get, url: url(for: path, parameters: parameters)))
    }
    
    private func request<Response: Decodable>(_ request: URLRequest) async throws -> Response {
        let (data, _) = try await self.request(request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode(Response.self, from: data)
    }
    
    private func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        do {
            let (data, response) = try await session.data(for: request)

            if let response = response as? HTTPURLResponse, !response.status.isSuccess {
                let message = String(data: data, encoding: .utf8)
                
                switch response.status {
                case .badRequest:
                    throw APIError.badRequest(message)
                case .notFound:
                    throw APIError.notFound
                default:
                    throw APIError.failure(response.status, data)
                }
            }
            
            return (data, response)
        } catch {
            throw error
        }
    }
    
    private func url(for path: String, parameters: Parameters? = nil) throws -> URL {
        if let url = URL(string: path, relativeTo: environment.host) {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            if let parameters {
                let queryItems = (components?.queryItems ?? []) + parameters.map{ URLQueryItem(name: $0.name, value: $0.value.description) }
                components?.queryItems = queryItems
            }
            
            if let url = components?.url {
                return url
            } else {
                throw URLError(.badURL)
            }
        } else {
            throw URLError(.badURL)
        }
    }
}
