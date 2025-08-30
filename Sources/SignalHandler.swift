//
//  SignalHandler.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 30/08/2025.
//

import Foundation
import SwiftMCP

public final class SignalHandler {
    
    // MARK: - Private Properties
    
    private let state: State
    
    
    
    // MARK: - Construction
    
    init(transport: HTTPSSETransport) {
        self.state = State(transport: transport)
    }
    
    
    
    // MARK: - Functions
    
    func setup() async {
        let signalQueue = DispatchQueue(label: "finch-mcp-server.signal-handler")
        await state.setupHandler(on: signalQueue)
    }
}

extension SignalHandler {
    actor State {
        
        // MARK: - Private Properties
        
        private var sigIntSource: DispatchSourceSignal?
        private var isShuttingDown = false
        private weak var transport: HTTPSSETransport?
        
        
        
        // MARK: - Construction
        
        init(transport: HTTPSSETransport) {
            self.transport = transport
        }
        
        
        // MARK: - Functions
        
        func setupHandler(on queue: DispatchQueue) {
            sigIntSource = DispatchSource.makeSignalSource(signal: SIGINT, queue: queue)
            
            signal(SIGINT, SIG_IGN)
            
            sigIntSource?.setEventHandler { [weak self] in
                Task { [weak self] in await self?.handleSignal() }
            }
            
            sigIntSource?.resume()
        }
        
        
        
        // MARK: - Private Functions
        
        private func handleSignal() async {
            guard !isShuttingDown else { return }
            isShuttingDown = true
            
            print("Shutting down...")
            
            guard let transport else {
                exit(1)
            }
            
            do {
                try await transport.stop()
                exit(0)
            } catch {
                print("Error during shutdown: \(error)")
                exit(1)
            }
        }
    }
}
