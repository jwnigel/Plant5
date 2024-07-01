//
//  DrawingEngine.swift
//  Plant5
//
//  Created by Nigel Wright on 02/03/24.
//

import Foundation
import SwiftUI


class DrawingEngine {
    
    func createPath(for points: [CGPoint]) -> Path {
         var path = Path()
        
        if let firstPoint = points.first {
            path.move(to: firstPoint)
        }
        
        for idx in 1..<points.count {
            let mid = calculateMidPoint(points[idx - 1], points[idx])
            path.addQuadCurve(to: mid, control: points[idx - 1])
        }
        
        if let last = points.last {
            path.addLine(to: last)
        }
        
        return path
    }
    
    
    func calculateMidPoint(_ point1: CGPoint, _ point2: CGPoint) -> CGPoint {
        let newMidPoint = CGPoint(x: (point1.x + point2.x) / 2, y: (point1.y + point2.y) / 2)
        return newMidPoint
    }
}
