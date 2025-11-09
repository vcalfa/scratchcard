//
//  Endpoint.swift
//  ScratchCardCore
//
//  Created by Vladimir Calfa on 09/11/2025.
//

import Foundation

enum Endpoint {
    case activateScratchCard(code: String)
    
    var path: String {
        switch self {
        case .activateScratchCard:
            "/version"
        }
    }
    
    var httpMethod: String {
        switch self {
        case .activateScratchCard:
            "GET"
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .activateScratchCard(let code):
            ["code": code]
        }
    }
}
