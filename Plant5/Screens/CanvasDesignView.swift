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
    var width: [Int]
}



struct CanvasDesignView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    @State private var draggablePlantIcons:  [DraggablePlantIcon] = []
    @State private var zoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    @State private var canvasDragOffset: CGSize = .zero

    
    
    var body: some View {
        ZStack {
            
            // DESIGN CANVAS GOES HERE
            Rectangle().foregroundColor(.yellow.opacity(0.2))
            
            ForEach(draggablePlantIcons.indices.sorted {
                // This returns the draggable icons sorted by width, from largest to smallest, so that the largest is placed first and the smallest last
                let width1 = CGFloat(draggablePlantIcons[$0].width.min() ?? 0)
                let width2 = CGFloat(draggablePlantIcons[$1].width.min() ?? 0)
                return width1 > width2
            }, id:\.self) { idx in
                let randomWidthWithinRange = CGFloat(draggablePlantIcons[idx].width.randomElement()!)
                Image(draggablePlantIcons[idx].imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: randomWidthWithinRange,
                           height: randomWidthWithinRange)
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
        }
        .scaleEffect(gestureZoomScale * zoomScale)
        .offset(canvasDragOffset)
        .background(Color.yellow.opacity(0.2))
        .gesture(
            DragGesture()
                .onChanged { value in
                    canvasDragOffset = value.translation
                }
                .onEnded { value in
                    canvasDragOffset = CGSize(width: canvasDragOffset.width + value.translation.width,
                                              height: canvasDragOffset.height + value.translation.height)
                }
        )
        
        
        //  CAN'T GET THIS TO WORK (MIGHT BE THE SIMULATOR) SO AM GOING TO USE + / - TO ZOOM FOR NOW
        
        .gesture(
            MagnificationGesture()
                .updating($gestureZoomScale, body: { (value, gestureState, transaction) in
                    gestureState = value // This correctly updates the gestureZoomScale
                    print("Pinching: \(value)")
                })
                .onEnded { value in
                    zoomScale *= value // Apply the final scale after the gesture ends
                }
        )

                    
        VStack {
            
            Spacer()
            
//            HStack {
//                    Button(action: {
//                        zoomScale += 0.1 // Zoom in
//                    }) {
//                        Text("+").font(.title).padding().background(Rectangle().fill(Color.white)).border(Color.secondary, width: 1)
//                    }
//                    Button(action: {
//                        zoomScale = max(zoomScale - 0.1, 0.1) // Zoom out, prevent scale from going below 0.1
//                    }) {
//                        Text("-").font(.title).padding().background(Rectangle().fill(Color.white)).border(Color.secondary, width: 1)
//                    }
//            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.myPalette.plants) { designPlant in
                        Button(action: {
                            self.draggablePlantIcons.append(DraggablePlantIcon(imageName: designPlant.iconName!,
                                                                               width: convertMeasurementToInches(designPlant.width!)))
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


