//
//  CanvasDesignView.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 25/02/24.
//

import SwiftUI


struct CanvasDesignView: View {
    
    @EnvironmentObject var viewModel: AppViewModel

    
    var body: some View {
        List {
            ForEach(viewModel.myPalette.plants, id: \.self) { plant in
                HStack {
                    if let width = plant.width {
                        let widthInches = convertMeasurementToInches(width)
                        let widthText = formatMeasurement(widthInches)
                        Text("Width: \(widthText)")
                    }
                    if let height = plant.height {
                        let heightInches = convertMeasurementToInches(height)
                        let heightText = formatMeasurement(heightInches)
                        Text("Height: \(heightText)")
                    }
                }
                    .font(.title2)
            }
        }

    }
}

