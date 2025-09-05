//
//  main.swift
//  FinchMCPServer
//
//  Created by Stefan Klein Nulent on 23/08/2025.
//

import Foundation
import SwiftMCP
import Logging
import FinchProtocol

let environment = try Environment()
let apiClient = APIClient(environment: environment)
let finchClient = Client(host: environment.finchHost, port: environment.finchPort)

let server = Server(finchClient: finchClient)
let transport = StdioTransport(server: server)
//let transport = HTTPSSETransport(server: server, port: 8018)
//transport.authorizationHandler = { _ in .authorized }

let signalHandler = SignalHandler(transport: transport)
await signalHandler.setup()

try await transport.run()
