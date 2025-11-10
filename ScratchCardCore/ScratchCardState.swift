//
//  ScratchCardState.swift
//  ScratchCardCore
//
//  Created by Vladimir Calfa on 08/11/2025.
//

import Foundation

public enum ScratchCardState: Equatable, Sendable {
    case unscratched
    case scratched
    case activated
}

extension ScratchCardState {
    func nextState() -> ScratchCardState? {
        switch self {
        case .unscratched:
            return .scratched
        case .scratched:
            return .activated
        case .activated:
            return .activated
        }
    }
}
