//
//  MainScreenViewModel.swift
//  ScratchCard
//
//  Created by Vladimir Calfa on 09/11/2025.
//

import SwiftUI
import ScratchCardCore

class MainScreenViewModel: ObservableObject {
    
    let cardService = ScratchCardService(codeGenerator: UUIDCodeGenerator(),
                                         apiService: APIService(baseURL: Constants.baseURL))
    init() {
        
    }
}
