//
//  MainScreenViewModel.swift
//  ScratchCard
//
//  Created by Vladimir Calfa on 09/11/2025.
//

import SwiftUI
import ScratchCardCore

enum CardState {
    case unscratched
    case scratched(String)
    case activated
}

struct ErrorDialog: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

final class MainScreenViewModel: ObservableObject, @unchecked Sendable {
    
    @Published var cardState: CardState?
    @Published var activationError: ErrorDialog?
    @Published var presentation: PresentationState?
    
    private var scratchTask: Task<Void, Never>?
    
    private var scratchCard: ScratchCardCore.ScratchCard<UUID>? {
        didSet {
            updateCode()
        }
    }
    
    let cardService = ScratchCardService(codeGenerator: UUIDCodeGenerator(),
                                         apiService: APIService(baseURL: Constants.baseURL))
    
    func newCard() {
        scratchCard = cardService.getScratchCard()
    }
    
    func scratch() {
        scratchTask?.cancel()
        scratchTask = Task {
            guard self.scratchCard != nil else { return }
            do {
                try await self.cardService.scratch(&self.scratchCard!)
            } catch { }
        }
    }
    
    func cancelScratchTask() {
        scratchTask?.cancel()
    }

    func activate() {
        Task {
            guard scratchCard != nil else { return }
            do {
                try await cardService.activate(&scratchCard!)
            } catch {
                Task.detached {
                    await MainActor.run {
                        self.activationError = ErrorDialog(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func updateCode() {
        let state = scratchCard?.state
        let code = scratchCard?.activationCode?.code ?? ""
        
        switch state {
        case .unscratched:
            cardState = .unscratched
        case .scratched:
            cardState = .scratched(code)
        case .activated:
            cardState = .activated
        case nil:
            cardState = nil
        @unknown default:
            cardState = nil
        }
    }
}
