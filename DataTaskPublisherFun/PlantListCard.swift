//
//  PlantListCard.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 22/02/24.
//

import SwiftUI

struct PlantListCard: View {
    
    var plant: Plant
    
    var body: some View {
        ZStack {
            Color(.brandPrimary!)
            HStack {
                
                VStack{
                    Text(plant.habit ?? "")
                    Text(plant.plantForm ?? "")
                }
                
                VStack {
                    Image(systemName: "arrow.left.and.right")
                    if plant.width == "indef" {
                        Image(systemName: "infinity")
                    } else {
                        Text(plant.width ?? "")

                    }
                }
                
                VStack {
                    Image(systemName: "arrow.up.and.down")
                    Text(plant.height ?? "")
                }
                
                VStack {
                    Text(plant.commonName?.capitalized ?? "Common Name")
                    Text(plant.latinName ?? "Latin Name")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                VStack {
                    if let plantLight = plant.light {
                        if plantLight.contains("F") {
                            Image(systemName: "sun.max")
                        }
                        if plantLight.contains("D") {
                            Image(systemName: "cloud.sun")
                        }
                        if plantLight.contains("S") {
                            Image(systemName: "cloud")
                        }
                    }
                }
            }
        }
        .frame(height: 70)
        .clipShape(RoundedRectangle(cornerRadius: 8)) // Clip the HStack to a rounded rectangle shape
        .overlay(
            RoundedRectangle(cornerRadius: 8) // Use RoundedRectangle as the shape for the overlay
                .stroke(Color(.brandSecondary!), lineWidth: 1) // Define the border color and line width
        )
    }
    
}

//struct PlantListCard_Previews: PreviewProvider {
//    static var previews: some View {
//        PlantListCard()
//    }
//}
