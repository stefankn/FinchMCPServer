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

let environment = try Environment()
let logger = Logger(label: "com.github.stefankn.finchmcpserver")
let apiClient = APIClient(environment: environment)

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
        )
    ])
}

await server.withMethodHandler(CallTool.self) { parameters in
    switch parameters.name {
    case "playlists":
        let playlists = try await apiClient.getPlaylists()
        let json = try JSONEncoder().encode(playlists)
        return .init(content: [.text(String(data: json, encoding: .utf8) ?? "No playlists found" )], isError: false)
    default:
        return .init(content: [.text("Unknown tool")], isError: true)
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
