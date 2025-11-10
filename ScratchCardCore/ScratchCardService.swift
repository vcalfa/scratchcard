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

public struct ScratchCardService<T: ScratchCodeProtocol & Sendable, Generator: CodeGeneratorProtocol>:  ScratchCardServiceProtocol where Generator.T == T {
    
    let apiService: any APIServiceProtocol
    let codeGenerator: Generator
    
    public init(codeGenerator: Generator, apiService: any APIServiceProtocol) {
        self.apiService = apiService
        self.codeGenerator = codeGenerator
    }
    
    public func getScratchCard() -> ScratchCard<T>  {
        return .init(generator: codeGenerator)
    }
    
    public func scratch(_ card: inout ScratchCard<T>) async throws {
        let newCard = card

        guard newCard.state == .unscratched else {
            card = newCard
            throw ScratchCardError.invalidState
        }
        
        do {
            try await Task.sleep(nanoseconds: .random(in: 1_000_000_000...3_000_000_000))
        } catch {
            card = newCard
            throw error
        }
        
        if Task.isCancelled {
            card = newCard
            return
        }
        
        card = newCard.scratch()
    }
    
    public func activate(_ card: inout ScratchCard<T>) async throws {
        let newCard = card
        guard newCard.state == .scratched,
              let code = newCard.activationCode?.code
        else {
            card = newCard
            throw ScratchCardError.invalidState
        }

        do {
            let activated = try await apiService.activateScratchCard(code: code)
            
            try await Task.sleep(nanoseconds: .random(in: 500_000_000...2_000_000_000))
            
            guard activated else {
                card = newCard
                return
            }
            
            card = newCard.activate()
        } catch {
            card = newCard
            throw error
        }
    }
}
