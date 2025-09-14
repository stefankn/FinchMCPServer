//
//  Server.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 30/08/2025.
//

import Foundation
import SwiftMCP
import FinchProtocol

@MCPServer(name: "Finch MCP server", version: "1.0.0")
actor Server {
    
    // MARK: - Private Properties
    
    private let finchClient: Client
    
    
    
    // MARK: - Construction
    
    init(finchClient: Client) {
        self.finchClient = finchClient
    }
    
    
    
    // MARK: - Functions
    
    /// Fetch a list of all available music playlists, including their IDs and names.
    @MCPTool
    func getPlaylists() async throws -> [Playlist] {
        try await apiClient.getPlaylists()
    }
    
    /**
     Search for albums, response includes artist, title and id.
     
     - Parameter query: The string to search for
     */
    @MCPTool
    func searchAlbums(query: String) async throws -> [Album] {
        let response = try await apiClient.searchAlbums(query: query)
        return response.items
    }
    
    /// Retrieve information about the currently playing song.
    @MCPTool
    func nowPlaying() async throws -> NowPlayingInfo {
        let response = try await finchClient.send(.nowPlayingInfo)
        if case let .nowPlayingInfo(info) = response {
            return info
        } else {
            throw ToolError.invalidResponse(response)
        }
    }
    
    /**
     Play a playlist
     
     - Parameter playlistId: The id of the playlist to play
     - Parameter shuffle: If the playlist tracks needs to be shuffled
     */
    @MCPTool
    func playPlaylist(playlistId: Int, shuffle: Bool) async throws -> String {
        let response = try await finchClient.send(.playPlaylist(playlistId: playlistId, shuffle: shuffle))
        if case .playPlaylist = response {
            return "Playlist started"
        }

        throw ToolError.invalidResponse(response)
    }
    
    /**
     Play an album
     
     - Parameter albumId: The id of the album to play
     - Parameter shuffle: If the album tracks needs to be shuffled
     */
    @MCPTool
    func playAlbum(albumId: Int, shuffle: Bool) async throws -> String {
        let response = try await finchClient.send(.playAlbum(albumId: albumId, shuffle: shuffle))
        if case .playAlbum = response {
            return "Started playing album"
        }

        throw ToolError.invalidResponse(response)
    }
    
    /**
     Plays the previous track in the queue
     */
    @MCPTool
    func playPreviousTrack() async throws -> String {
        let response = try await finchClient.send(.playPreviousTrack)
        if case .playNextTrack = response {
            return "Playing previous track"
        }
        
        throw ToolError.invalidResponse(response)
    }
    
    /**
     Plays the next track in the queue
     */
    @MCPTool
    func playNextTrack() async throws -> PlayResult {
        let response = try await finchClient.send(.playNextTrack)
        if case let .playNextTrack(result) = response {
            return result
        }
        
        throw ToolError.invalidResponse(response)
    }
    
    /**
     Starts playing the current track
     */
    @MCPTool
    func play() async throws -> String {
        let response = try await finchClient.send(.play)
        if case .play = response {
            return "Started playing"
        }
        
        throw ToolError.invalidResponse(response)
    }
    
    /**
     Pauses the current track
     */
    @MCPTool
    func pause() async throws -> String {
        let response = try await finchClient.send(.pause)
        if case .play = response {
            return "Player paused"
        }
        
        throw ToolError.invalidResponse(response)
    }
}
