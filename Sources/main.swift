//
//  main.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 23/08/2025.
//

import Foundation
import MCP
import ServiceLifecycle
import Logging
import FinchProtocol

let environment = try Environment()
let logger = Logger(label: "com.github.stefankn.finchmcpserver")

let apiClient = APIClient(environment: environment)
let finchClient = Client(host: environment.finchHost, port: environment.finchPort)

let server = Server(
    name: "Finch MCP server",
    version: "1.0.0",
    capabilities: .init(
        prompts: .init(listChanged: true),
        resources: .init(subscribe: true, listChanged: true),
        tools: .init(listChanged: true)
    )
)

await server.withMethodHandler(ListTools.self) { _ in
    .init(tools: [
        Tool(
            name: "playlists",
            description: "Returns a list of all available music playlists",
            inputSchema: .object([
                "type": "object",
                "properties": .object([:])
            ])
        ),
        Tool(
            name: "now_playing",
            description: "Retrieve information about the currently playing song",
            inputSchema: .object([
                "type": "object",
                "properties": .object([:])
            ])
        ),
        Tool(
            name: "play_playlist",
            description: "Play a playlist",
            inputSchema: .object([
                "type": "object",
                "properties": .object([
                    "playlistId": .object([
                        "type": "string",
                        "description": .string("The identifier for the playlist to play")
                    ])
                ])
            ])
        )
    ])
}

await server.withMethodHandler(CallTool.self) { parameters in
    do {
        switch parameters.name {
        case "playlists":
            let playlists = try await apiClient.getPlaylists()
            let json = try JSONEncoder().encode(playlists)
            return .init(content: [.text(String(data: json, encoding: .utf8) ?? "" )], isError: false)
        case "now_playing":
            let response = try await finchClient.send(.nowPlayingInfo)
            if case let .nowPlayingInfo(info) = response {
                let json = try JSONEncoder().encode(info)
                return .init(content: [.text(String(data: json, encoding: .utf8) ?? "" )], isError: false)
            } else {
                throw ToolError.invalidResponse(response)
            }
        case "play_playlist":
            if let playlistId = parameters.arguments?["playlistId"]?.intValue {
                let response = try await finchClient.send(.playPlaylist(playlistId: playlistId))
                if case .playPlaylist = response {
                    return .init(content: [.text("Playlist started")])
                }
                
                throw ToolError.invalidResponse(response)
            }
            
            throw ToolError.invalidArgument
        default:
            throw ToolError.unknownTool(parameters.name)
        }
    } catch {
        return .init(content: [.text("Tool failed: \(error.localizedDescription)")], isError: true)
    }
}

let transport = StdioTransport(logger: logger)
let service = MCPService(server: server, transport: transport)
let serviceGroup = ServiceGroup(
    services: [service],
    gracefulShutdownSignals: [.sigterm, .sigint],
    logger: logger
)

try await serviceGroup.run()
