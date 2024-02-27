//
//  PaletteView.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 23/02/24.
//

import SwiftUI

struct PaletteView: View {
    
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        List {
            ForEach(viewModel.myPalette.plants, id: \.self) { plant in
                Text(plant.commonName?.capitalized ?? "Oops, no name found")
                    .font(.title2)
            }
            .onDelete(perform: deletePlant)
        }
    }

    private func deletePlant(at offsets: IndexSet) {
        viewModel.myPalette.plants.remove(atOffsets: offsets)
    }
}


struct PaletteView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteView()
    }
}
