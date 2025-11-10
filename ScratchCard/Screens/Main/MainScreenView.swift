//
//  MainScreenView.swift
//  ScratchCard
//
//  Created by Vladimir Calfa on 08/11/2025.
//

import SwiftUI

struct MainScreenView: View {
    
    @StateObject private var viewModel = MainScreenViewModel()
    
    @State private var showScratchView = false
    @State private var showActivationView = false
    
    @State private var scratchTask: Task<Void, Never>? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            ScratchCard(state: viewModel.cardState)
            Spacer()
            VStack {
                Button(action: { viewModel.newCard() }) {
                    Label("New", systemImage: "plus.circle")
                        .frame(maxWidth: .infinity, minHeight: 40, alignment: .center)
                }
                
                HStack {
                    Button(action: { showScratchView.toggle()  }) {
                        Label("Scratch", systemImage: "sparkles")
                            .frame(maxWidth: .infinity, minHeight: 40, alignment: .center)
                    }
                    
                    Button(action: { showActivationView.toggle() }) {
                        Label("Activate", systemImage: "lightbulb.max")
                            .frame(maxWidth: .infinity, minHeight: 40, alignment: .center)
                    }
                }
            }
        }
        .task {
            viewModel.newCard()
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $showScratchView) {
            Button(action: {
                viewModel.scratch()
            }) {
                Text("Scratch card")
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
            .presentationDetents([.fraction(0.2)])
            .presentationDragIndicator(.visible)
            .onDisappear() {
                viewModel.cancelScratchTask()
            }
            
        }
        .sheet(isPresented: $showActivationView) {
            Button(action: {
                viewModel.activate()
            }) {
                Text("Activate card")
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
            .presentationDetents([.fraction(0.2)])
            .presentationDragIndicator(.visible)
        }
//        .alert(item: $viewModel.activationError) { error in
//            Alert(
//                title: Text("Error"),
//                message: Text(error.message),
//                dismissButton: .default(Text("OK")) {
//                    viewModel.activationError = nil
//                }
//            )
//        }
    }
}

#Preview {
    MainScreenView()
}
