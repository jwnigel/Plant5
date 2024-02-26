//
//  AddToPaletteButton.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 25/02/24.
//

import SwiftUI


struct AddToPaletteButton: View {
    @Binding var addToPaletteButtonPressed: Bool
    var viewModel: AppViewModel
    var plant: Plant // Ensure plant is passed to the button
    
    var body: some View {
        Button("Add to palette") {
            addToPaletteButtonPressed.toggle()
            
            viewModel.addToPalette(plant)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeOut(duration: 0.2)) {
                    addToPaletteButtonPressed.toggle()
                }
            }
        }

        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(addToPaletteButtonPressed ? Color.brandSecondary.opacity(0.7) : Color.brandSecondary)
        .foregroundColor(.brandPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 4)
        .scaleEffect(addToPaletteButtonPressed ? 1.06 : 1.0)
        .animation(.easeOut(duration: 0.2), value: addToPaletteButtonPressed)
        .padding(18)
    }
}

