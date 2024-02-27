//
//  CanvasDesignView.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 25/02/24.
//

import SwiftUI


struct DraggableCircle {
    var id = UUID()
    var currentDragOffset = CGSize.zero
    var totalDragOffset = CGSize.zero
    let circleColor: Color
}



struct CanvasDesignView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    @State private var draggableCircles:  [DraggableCircle] = []

    
    private var colors: [Color] = [Color.red, Color.blue, Color.yellow, Color.green, Color.purple, Color.orange, Color.pink, Color.brown, Color.cyan, Color.teal]

    
    var body: some View {
                ZStack {
                    
                    // DESIGN CANVAS GOES HERE
                    
                    ForEach(draggableCircles.indices, id:\.self) { idx in
                        Circle()
                            .frame(width: 100, height: 100)
                            .offset(x: draggableCircles[idx].currentDragOffset.width + draggableCircles[idx].totalDragOffset.width,
                                    y: draggableCircles[idx].currentDragOffset.height + draggableCircles[idx].totalDragOffset.height)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        draggableCircles[idx].currentDragOffset = value.translation
                                    }
                                    .onEnded { value in
                                        draggableCircles[idx].totalDragOffset = CGSize(width: draggableCircles[idx].totalDragOffset.width + value.translation.width,
                                                                                       height: draggableCircles[idx].totalDragOffset.height + value.translation.height)
                                        draggableCircles[idx].currentDragOffset = CGSize.zero
                                    }
                            )
                    }
                    
                    
                    VStack {
                        Spacer()
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.myPalette.plants) { designPlant in
                                    let plantColor = colors.randomElement()
                                    Button(action: {
                                        self.draggableCircles.append(DraggableCircle(circleColor: plantColor!))
                                    }) {
                                        ZStack {
                                            Circle()
                                                 .frame(width: 100, height: 100)
                                                 .foregroundColor(plantColor)
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

