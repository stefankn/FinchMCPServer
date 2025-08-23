//
//  MCPService.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 23/08/2025.
//

import ServiceLifecycle
import MCP

struct MCPService: Service {
    
    // MARK: - Private Properties
    
    private let server: Server
    private let transport: Transport
    
    
    
    // MARK: - Construction
    
    init(server: Server, transport: Transport) {
        self.server = server
        self.transport = transport
    }
    
    
    
    // MARK: - Functions
    
    // MARK: Service Functions
    
    func run() async throws {
        try await server.start(transport: transport)
        try await Task.sleep(for: .seconds(60 * 60 * 24 * 365 * 100))
    }
    
    func shutdown() async {
        await server.stop()
    }
}
