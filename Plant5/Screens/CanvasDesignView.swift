//
//  CanvasDesignView.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 25/02/24.
//

import SwiftUI

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
    @GestureState private var gestureState = CGSize.zero
    
    @State private var canvasDragOffset: CGSize = .zero
    @State private var tempCanvasDragOffset: CGSize = .zero
    
    @State private var drawingEnabled: Bool = false
    @State private var drawingScreen = DrawingView()
    
    // Row Canvas Vars:
    
    @State private var lines = [Line]()
    @State private var deletedLines = [Line]()
    
    @State private var selectedColor: Color = .black
    @State private var selectedLineWidth: CGFloat = 2.0
    
    let engine = DrawingEngine()
    @State private var showConfirmation: Bool = false
    
    @State private var showDimensionEditor: Bool = false
    
    @State private var canvasWidth: Double = 800
    let minX: CGFloat = -10
    var maxX: CGFloat { canvasWidth + 10 }
    
    @State private var canvasHeight: Double = 800
    let minY: CGFloat = -10
    var maxY: CGFloat { canvasHeight + 10 }
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    // Add minimum zoom scale (calculated later)
    @State private var minZoomScale: CGFloat = 1.0
    
    
    
    var body: some View {
        
        ZStack {
            
            Rectangle().foregroundColor(.pink.opacity(0.1))
                .frame(width: canvasWidth, height: canvasHeight, alignment: .center)
            
            if !drawingEnabled {
                Canvas { context, size in
                    for line in lines {
                        let path = engine.createPath(for: line.points)
                        context.stroke(path,
                                       with: .color(line.color),
                                       style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                    }
                }
                .opacity(drawingEnabled ? 0.0 : 0.7)
                .animation(.easeInOut(duration: 1.5), value: drawingEnabled)
            }
            
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
                    .contextMenu {
                        Button("Read More") {
                            print("Read More tapped")
                        }
                        Button("Delete") {
                            print("Delete tapped")
                        }
                    }
            }
            if drawingEnabled {
                Canvas { context, size in
                    
                    for line in lines {
                        
                        
                        let path = engine.createPath(for: line.points)
                        
                        
                        context.stroke(path,
                                       with: .color(line.color),
                                       style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                    }
                }
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ value in
                    let newPoint = value.location
                    if value.translation.width + value.translation.height == 0 {
                        lines.append(Line(points: [newPoint], color: selectedColor, lineWidth: selectedLineWidth))
                    } else {
                        let idx = lines.count - 1
                        lines[idx].points.append(newPoint)
                    }
                }).onEnded({ value in
                    if let last = lines.last?.points, last.isEmpty {
                        lines.removeLast()
                    }
                })
                )
            }
            
//            VStack(alignment: .center) {
//                Text("zoomScale: \(zoomScale)")
//                Text("minZoomScale: \(minZoomScale)")
//                Text("canvasDragOffset: \(canvasDragOffset.width) x \(canvasDragOffset.height)")
//                Text("Canvas size: \(canvasWidth) x \(canvasHeight)")
//            }
        }
        .onAppear {
            calculateMinZoomScale()
        }
        .onChange(of: canvasWidth) { _ in calculateMinZoomScale() }
        .onChange(of: canvasHeight) { _ in calculateMinZoomScale() }
        
        .scaleEffect(gestureZoomScale * zoomScale)
        .offset(x: canvasDragOffset.width + tempCanvasDragOffset.width, y: canvasDragOffset.height + tempCanvasDragOffset.height)
        
        .gesture(
            drawingEnabled ? nil : DragGesture()
                .updating($gestureState) { (value, gestureState, transaction) in
                    let scaleAdjustedTranslation = CGSize(
                        width: value.translation.width / (gestureZoomScale * zoomScale),
                        height: value.translation.height / (gestureZoomScale * zoomScale)
                    )
                    
                    let newTempX = min(max(canvasDragOffset.width + scaleAdjustedTranslation.width, minX), maxX)
                    let newTempY = min(max(canvasDragOffset.height + scaleAdjustedTranslation.height, minY), maxY)
                    
                    gestureState = CGSize(width: newTempX - canvasDragOffset.width, height: newTempY - canvasDragOffset.height)
                }
                .onEnded { value in
                    adjustCanvasDragOffset(finalScaleAdjustedTranslation: value.translation)
                }
        )
    
        .gesture(
            MagnificationGesture()
                .updating($gestureZoomScale, body: { (value, gestureState, transaction) in
                    let tempScale = zoomScale * value
                    gestureState = tempScale < minZoomScale ? minZoomScale / zoomScale : value
                })
                .onEnded { value in
                    let tempScale = zoomScale * value
                    zoomScale = max(minZoomScale, tempScale)
                }
        )
        
        .overlay {
            ZStack {
                // Drawing UI Stack
                VStack {
                    if drawingEnabled {
                        HStack {
                            ColorPicker("Line Color", selection: $selectedColor, supportsOpacity: true)
                            
                            Slider(value: $selectedLineWidth, in: 1...20) {
                                Text("Line Width")
                            }
                            .frame(maxWidth: 100)
                            Text(String(format: "%.0f", selectedLineWidth))
                            
                            Button {
                                let last = lines.removeLast()
                                deletedLines.append(last)
                            } label: {
                                Image(systemName: "arrow.uturn.backward.circle")
                                    .imageScale(.large)
                            }
                            .disabled(lines.count == 0)
                            
                            Button {
                                let next = deletedLines.removeLast()
                                lines.append(next)
                            } label: {
                                Image(systemName: "arrow.uturn.forward.circle")
                                    .imageScale(.large)
                            }
                            .disabled(deletedLines.count == 0)
                            
                            Button(action: {
                                showConfirmation = true
                            }) {
                                Text("Delete")
                                    .foregroundColor(.red)
                            }
                            .confirmationDialog(Text("Are you sure you want to delete everything?"), isPresented: $showConfirmation) {
                                Button("Delete", role: .destructive) {
                                    lines = [Line]()
                                    deletedLines = [Line]()
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                
                // Plant icons and toggle drawing buttons
                VStack {
                    
                    Spacer()
                    
                    HStack {
                        Toggle("Draw", isOn: $drawingEnabled)
                        Button {
                            showDimensionEditor.toggle()
                        } label: {
                            Image(systemName: "slider.vertical.3")
                        }
                    }
                    .padding()
                    
                    ZStack {
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
                    .frame(width: screenWidth - 20, height: viewModel.myPalette.plants.isEmpty ? 10 : 120, alignment: .center)
                    
                }
                .frame(width: screenWidth - 20)
            }
        }
        
        
        
        if showDimensionEditor {
            VStack {
                Button {
                    showDimensionEditor = false
                } label: {
                    HStack {
                        Spacer()
                        XDismissButton()
                    }
                }
                Form {
                    TextField("Width", value: $canvasWidth, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Height", value: $canvasHeight, format: .number)
                        .keyboardType(.decimalPad)
                }
            }
            .frame(width: screenWidth - 20, height: screenHeight - 40, alignment: .center)
            
        }
        
    }
    
    
    private func calculateMinZoomScale() {
        // Screen dimensions
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        // Calculate the zoom scale required for both width and height to match the screen size
        let zoomScaleForWidth = screenWidth / CGFloat(canvasWidth)
        let zoomScaleForHeight = screenHeight / CGFloat(canvasHeight)
        
        // Set minZoomScale to the larger of the two zoom scales
        // This ensures that at least one dimension fills the screen
        minZoomScale = max(zoomScaleForWidth, zoomScaleForHeight)
    }
    
    
    private func adjustCanvasDragOffset(finalScaleAdjustedTranslation: CGSize) {
        // This conversion ensures we're working with the scale-adjusted translation.
        let translation = CGSize(
            width: finalScaleAdjustedTranslation.width / zoomScale,
            height: finalScaleAdjustedTranslation.height / zoomScale
        )

        // Tentatively update the drag offset based on the translation.
        var tentativeOffset = CGSize(
            width: canvasDragOffset.width + translation.width,
            height: canvasDragOffset.height + translation.height
        )

        // Calculate the scaled dimensions of the canvas.
        let scaledCanvasWidth = canvasWidth * Double(zoomScale)
        let scaledCanvasHeight = canvasHeight * Double(zoomScale)

        // Determine the bounds for the drag offset to keep the canvas visible.
        let horizontalBound = max(0, (scaledCanvasWidth - Double(screenWidth)) / 2)
        let verticalBound = max(0, (scaledCanvasHeight - Double(screenHeight)) / 2)

        // Apply the bounds to the tentative offset.
        tentativeOffset.width = max(min(tentativeOffset.width, horizontalBound), -horizontalBound)
        tentativeOffset.height = max(min(tentativeOffset.height, verticalBound), -verticalBound)

        // Update the actual drag offset with the constrained value.
        canvasDragOffset = tentativeOffset
    }

    
}


