//
//  CanvasDesignView.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 25/02/24.
//

import SwiftUI




// Icon Image names
let pdfAssetNames = ["tree_icon_1", "tree_icon_2", "tree_icon_3", "tree_icon_4", "tree_icon_5", "tree_icon_6"]


struct DraggablePlantIcon {
    var id = UUID()
    var currentDragOffset = CGSize.zero
    var totalDragOffset = CGSize.zero
    var imageName: String
}



struct CanvasDesignView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    @State private var draggablePlantIcons:  [DraggablePlantIcon] = []

    
    var body: some View {
                ZStack {
                    
                    // DESIGN CANVAS GOES HERE
                    
                    ForEach(draggablePlantIcons.indices, id:\.self) { idx in
                        Image(draggablePlantIcons[idx].imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .offset(x: draggablePlantIcons[idx].currentDragOffset.width + draggablePlantIcons[idx].totalDragOffset.width,
                                    y: draggablePlantIcons[idx].currentDragOffset.height + draggablePlantIcons[idx].totalDragOffset.height)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        draggablePlantIcons[idx].currentDragOffset = value.translation
                                    }
                                    .onEnded { value in
                                        draggablePlantIcons[idx].totalDragOffset = CGSize(width: draggablePlantIcons[idx].totalDragOffset.width + value.translation.width,
                                                                                       height: draggablePlantIcons[idx].totalDragOffset.height + value.translation.height)
                                        draggablePlantIcons[idx].currentDragOffset = CGSize.zero
                                    }
                            )
                    }
                    
                    
                    VStack {
                        Spacer()
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.myPalette.plants) { designPlant in
                                    
                                    Button(action: {
                                        self.draggablePlantIcons.append(DraggablePlantIcon(imageName: designPlant.iconName!))
                                    }) {
                                        ZStack {
                                            Image(designPlant.iconName!)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                            
                                            Text("\(designPlant.commonName?.capitalized ?? "NAME")")
                                                .foregroundColor(.white)
                                                .lineLimit(2)
                                                .truncationMode(.tail)
                                                .padding(6)
                                                .frame(width: 100, height: 100)
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }

        }

    }
}

