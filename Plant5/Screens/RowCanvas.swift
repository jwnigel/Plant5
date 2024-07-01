//
//  RowCanvas.swift
//  Plant5
//
//  Created by Nigel Wright on 02/03/24.
//
//
//import SwiftUI
//
//
//struct RowCanvas: View {
//    
//    var lines: [Line]
//    var engine: DrawingEngine
//    var selectedColor: Color
//    var selectedLineWidth: CGFloat
//    
//    
//    var body: some View {
//        
//        Canvas { context, size in
//            
//            for line in lines {
//            
//                
//                let path = engine.createPath(for: line.points)
//
//                
//                context.stroke(path,
//                               with: .color(line.color),
//                               style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
//            }
//        }
//        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ value in
//            let newPoint = value.location
//            if value.translation.width + value.translation.height == 0 {
//                // TODO: Add selected color and line width
//                lines.append(Line(points: [newPoint], color: selectedColor, lineWidth: selectedLineWidth))
//            } else {
//                let idx = lines.count - 1
//                lines[idx].points.append(newPoint)
//            }
//        }).onEnded({ value in
//            if let last = lines.last?.points, last.isEmpty {
//                lines.removeLast()
//            }
//        })
//                 )
//        
//    }
//}
//
