//
//  DrawingView.swift
//  Plant5
//
//  Created by Nigel Wright on 02/03/24.
//


import SwiftUI

struct DrawingView: View {
        
    
    @State private var lines = [Line]()
    @State private var deletedLines = [Line]()
    
    @State private var selectedColor: Color = .black
    @State private var selectedLineWidth: CGFloat = 2.0
    
    let engine = DrawingEngine()
    @State private var showConfirmation: Bool = false
    
    
    var body: some View {
        
        VStack {
            
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
                    // TODO: Add selected color and line width
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
        
    }
    
}



struct Line {
    
    var points: [CGPoint]
    var color: Color
    var lineWidth: CGFloat
    
}


struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
