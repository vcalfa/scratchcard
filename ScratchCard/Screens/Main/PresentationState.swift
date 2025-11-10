//
//  PresentationState.swift
//  ScratchCard
//
//  Created by Vladimir Calfa on 09/11/2025.
//

import Foundation

enum PresentationState: Identifiable {
    case scratching
    case activation
    case alert(String, String)

    var id: String {
        switch self {
        case .scratching: "scratching"
        case .activation: "activation"
        case .alert(_, let message): message
        }
    }
}
