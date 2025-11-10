//
//  ScratchCard.swift
//  ScratchCardCore
//
//  Created by Vladimir Calfa on 08/11/2025.
//

import Foundation

public struct ScratchCard<T: ScratchCodeProtocol>: ~Copyable, @unchecked Sendable {
    let id: UUID
    public let state: ScratchCardState
    private let code: T
    
    internal init(code: T) {
        id = UUID()
        self.code = code
        state = .unscratched
    }
    
    internal init(id: UUID, code: T, state: ScratchCardState) {
        self.id = id
        self.code = code
        self.state = state
    }
    
    consuming public func scratch() -> Self {
        guard let state = state.nextState(), state == .scratched else {
            return .init(id: id, code: code, state: state)
        }
        return .init(id: id, code: code, state: state)
    }
    
    consuming public func activate() -> Self {
        guard let state = state.nextState(), state == .activated else {
            return .init(id: id, code: code, state: state)
        }
        return .init(id: id, code: code, state: state)
    }
    
    public var activationCode: T? {
        switch state {
        case .unscratched:
            return nil
        case .scratched:
            return code
        case .activated:
            return nil
        }
    }
}

extension ScratchCard {
    init<G: CodeGeneratorProtocol>(generator: G) where G.T == T {
        self.init(code: generator.generateCode())
    }
}
