//
//  ScratchCardServiceProtocol.swift
//  ScratchCardCore
//
//  Created by Vladimir Calfa on 08/11/2025.
//

import Foundation

public protocol ScratchCardServiceProtocol {
    associatedtype T: ScratchCodeProtocol
    
    func getScratchCard() -> ScratchCard<T>
    
    func scratch(_ card: inout ScratchCard<T>) async throws
    
    func activate(_ card: inout ScratchCard<T>) async throws
}
