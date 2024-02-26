//
//  PlantCard.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 22/02/24.
//


import SwiftUI

struct PlantDetailCard: View {
    
    var plant: Plant
    @EnvironmentObject var viewModel: AppViewModel
    @State private var imageIdx: Int = 0
    @State private var addToPalleteButtonPressed = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                TabView {
                    VStack {
                        Spacer()
                        if let myImage = viewModel.images[safe: imageIdx] {
                            myImage
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .frame(width: 320, height: 200)
                                .onTapGesture {
                                    switchPlantImage()
                                }
                        }
                        Text(plant.commonName?.capitalized ?? "Common Name")
                            .foregroundColor(.primary)
                        Text(plant.latinName ?? "Latin Name")
                            .foregroundColor(.secondary)
                        // Plant Structure
                        Group {
                            Text("\(plant.habit ?? "") \(plant.plantForm ?? "")")
                            HStack {
                                Text("Width: \(plant.width ?? "")")
                                Text("Height: \(plant.height ?? "")")
                            }
                            if let growthRate = plant.growthRate {
                                Text("Growth Rate: \(growthRate)")
                            }
                            if let rootPattern = plant.rootPattern {
                                Text("Root Pattern: \(rootPattern)")
                            }
                        }
                        Spacer()
                    }
                    .tag(1)
                    .padding(.bottom, 60)
                    
                    //End TabView 1
                    VStack {
                        // Plant Preferences
                        Group {
                            if let zones = plant.hardinessZones {
                                Text("Hardiness Zones: \(zones)")
                            }
                            HStack {
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
                            if let moisture = plant.moisture {
                                Text("Moisture: \(moisture)")
                            }
                            if let soil = plant.soilAcidity {
                                Text("Soil: \(soil)")
                            }
                            if let nativeTo = plant.nativeRegion {
                                Text("Native to: \(nativeTo)")
                            }
                            if let ecosystem = plant.ecosystemString {
                                Text("Ecosystem: \(ecosystem)")
                            }
                        }
                        
                        // Plant Uses
                        Group {
                            if let edible = plant.edibleString {
                                Text("Edible: \(edible)")
                            } else {
                                Text("Not edible")
                            }
                            if let medicinal = plant.medicinal {
                                Text("Medicinal: \(medicinal)")
                            }
                            
                        }
                    }
                    .tag(2)
                    .padding(.bottom, 60)
                    
                    VStack {
                        Text("More Info")
                        Text("More Images")
                        
                    }
                    .tag(3)
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .padding(.bottom, 70)
                
                VStack {
                    Spacer ()
                    AddToPaletteButton(addToPaletteButtonPressed: $addToPalleteButtonPressed, viewModel: viewModel, plant: plant)
                }
            }
        }
        .font(.title2)
        .background(Color.brandPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.brandSecondary, lineWidth: 1)
        )
        .padding(.horizontal, viewModel.plantDetailCardXPadding)
        .padding(.vertical, viewModel.plantDetailCardYPadding)

        .onAppear {
            fetchPlantMedia()
        }
        
    }
    
    private func fetchPlantMedia() {
        viewModel.fetchUsageKey(for: plant) { media in
            if let media = media {
                DispatchQueue.main.async {
                    plant.gbifUsageKey = Int64(media.usageKey)
                    viewModel.getPlantGallery(for: plant)
                }
            } else {
                viewModel.errorForAlert = ErrorForAlert(message: "Couldn't fetch media for selectedPlant \(plant)")
            }
        }
    }
    
    
    private func switchPlantImage() {
        if imageIdx < viewModel.images.count - 1 {
            imageIdx += 1
        } else {
            imageIdx = 0
        }
    }
}

//struct PlantCard_Previews: PreviewProvider {
//    static var previews: some View {
//        PlantCard()
//    }
//}


extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
