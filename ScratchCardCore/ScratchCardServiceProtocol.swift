//
//  ScratchCardServiceProtocol.swift
//  ScratchCardCore
//
//  Created by Vladimir Calfa on 08/11/2025.
//

import Foundation

public protocol ScratchCardServiceProtocol {
    associatedtype T: ScratchCodeProtocol
    
    func getScratchCard() async -> ScratchCard<T>
    
    func scratchCard(_ card: consuming ScratchCard<T>) async throws -> ScratchCard<T>
    
    func activateCard(_ card: consuming ScratchCard<T>) async throws -> ScratchCard<T>
}
