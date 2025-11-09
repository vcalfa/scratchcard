//
//  MainScreenView.swift
//  ScratchCard
//
//  Created by Vladimir Calfa on 08/11/2025.
//

import SwiftUI


struct MainScreenView: View {
    @StateObject private var viewModel = MainScreenViewModel()
    
    var body: some View {
        VStack {
            Button(action: { }, label: {
                Text("")
            })
            Button(action: { }, label: {
                Text("")
            })
        }
        .padding()
    }
}

#Preview {
    MainScreenView()
}
