//
//  ScratchCardViewModel.swift
//  ScratchCard
//
//  Created by Vladimir Calfa on 09/11/2025.
//

import Combine
import SwiftUI

final class ScratchCardViewModel: ObservableObject {
    
    @Published var backgroundColor: Color = .gray
    @Published var text: String
    
    init(state: CardState?) {
        switch state {
        case .none:
            text = ""
            backgroundColor = .red
        case .some(let state):
            switch state {
            case .scratched(let code):
                text = "Scratched Card\nCode: \(code)"
                backgroundColor = .green
            case .activated:
                text = "Activated Card"
                backgroundColor = .gray
            case .unscratched:
                text = "Unscratched Card"
                backgroundColor = .blue
            }
        }
    }
}
