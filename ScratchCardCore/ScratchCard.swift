//
//  ScratchCard.swift
//  ScratchCardCore
//
//  Created by Vladimir Calfa on 08/11/2025.
//

import Foundation

public struct ScratchCard<T: ScratchCodeProtocol>: ~Copyable {
    let id: UUID
    let state: ScratchCardState
    private let code: T
    
    internal init(code: T) {
        id = UUID()
        self.code = code
        state = .unscratched
    }
    
    internal init(scratchCard: consuming ScratchCard) throws {
        id = scratchCard.id
        code = scratchCard.code
        guard let state = scratchCard.state.nextState(), state == .scratched else {
            throw ScratchCardError.invalidState
        }
        self.state = state
    }
    
    internal init(activateCard: consuming ScratchCard) throws {
        id = activateCard.id
        code = activateCard.code
        guard let state = activateCard.state.nextState(), state == .activated else {
            throw ScratchCardError.invalidState
        }
        self.state = state
    }
    
    public var activationCode: T? {
        switch state {
        case .unscratched:
            return nil
        case .scratched:
            return code
        case .activated:
            return code
        }
    }
}

extension ScratchCard {
    init<G: CodeGeneratorProtocol>(generator: G) where G.T == T {
        self.init(code: generator.generateCode())
    }
}
