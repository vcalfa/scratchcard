//
//  ScratchCard.swift
//  ScratchCard
//
//  Created by Vladimir Calfa on 08/11/2025.
//

import SwiftUI

struct ScratchCard: View {
    
    @ObservedObject private var viewModel: ScratchCardViewModel
    
    init(state: CardState?) {
        _viewModel = ObservedObject(wrappedValue: ScratchCardViewModel(state: state))
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(viewModel.backgroundColor)
                
                .shadow(radius: 5)
            
            VStack {
                Text(viewModel.text)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .animation(.easeInOut, value: viewModel.backgroundColor)
            }
        }
        .frame(width: 250, height: 350)
        .padding()
    }
}

#Preview {
    ScratchCard(state: .unscratched)
}

#Preview {
    ScratchCard(state: .scratched("123"))
}

#Preview {
    ScratchCard(state: .activated)
}
