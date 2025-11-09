//
//  ScratchCardService.swift
//  ScratchCardCore
//
//  Created by Vladimir Calfa on 08/11/2025.
//

import Foundation

enum ScratchCardError: Error {
    case invalidState
    case incorrectScratchCardState
}

//@Observable
public struct ScratchCardService<T: ScratchCodeProtocol, Generator: CodeGeneratorProtocol>: ScratchCardServiceProtocol where Generator.T == T {
    
    let apiService: any APIServiceProtocol
    let codeGenerator: Generator
    
    public init (codeGenerator: Generator, apiService: any APIServiceProtocol) {
        self.apiService = apiService
        self.codeGenerator = codeGenerator
    }
    
    public func getScratchCard() async -> ScratchCard<T>  {
        return .init(generator: codeGenerator)
    }
    
    public func scratchCard(_ card: consuming ScratchCard<T>) async throws -> ScratchCard<T> {
        try await Task.sleep(nanoseconds: .random(in: 500_000_000...2_000_000_000))
        
        if Task.isCancelled {
            return card
        }
        let card = try ScratchCard(scratchCard: card)
        return card
    }
    
    public func activateCard(_ card: consuming ScratchCard<T>) async throws -> ScratchCard<T> {
        
        guard let code = card.activationCode?.code else {
            throw ScratchCardError.invalidState
        }
        
        let activated = try await apiService.activateScratchCard(code: code)
        
        try await Task.sleep(nanoseconds: .random(in: 500_000_000...2_000_000_000))

        if activated {
            return try ScratchCard(activateCard: card)
        }
        
        return card
    }
}
