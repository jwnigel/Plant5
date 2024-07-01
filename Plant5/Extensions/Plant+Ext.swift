//
//  Plant+Ext.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 22/02/24.
//

import CoreData
import SwiftUI


extension Plant {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.setValue(UUID(), forKey: "uuid")
    }
    
    func assignRandomImage() {
        self.iconName = pdfAssetNames.randomElement()!
    }
}



func convertMeasurementToInches(_ measurement: String) -> [Int] {
    let components = measurement.components(separatedBy: "-")
    return components.compactMap { component -> Int? in
        let trimmed = component.trimmingCharacters(in: .whitespaces)
        if let feetRange = trimmed.range(of: "'") {
            let feetValue = trimmed[..<feetRange.lowerBound]
            if let feet = Int(feetValue) {
                return feet * 12 
            }
        } else if let inchesRange = trimmed.range(of: "\"") {
            let inchesValue = trimmed[..<inchesRange.lowerBound]
            return Int(inchesValue)
        }
        return nil
    }
}



func formatMeasurement(_ measurements: [Int]) -> String {
     switch measurements.count {
     case 0:
         return "N/A"
     case 1:
         return "\(measurements.first!) inches"
     default:
         return "\(measurements.first!) - \(measurements.last!) inches"
     }
 }



extension Plant {
    var displayIconImage: Image {
        let imageName: String
        switch plantForm!.lowercased() {
        case "tree":
            imageName = "treeIcon1" // Assuming "treeIcon" is the name of your image asset for trees
        case "shrub":
            imageName = "shrubIcon1" // Assuming "shrubIcon" is the name of your image asset for shrubs
        case "herb":
            imageName = "herbIcon1" // Assuming "herbIcon" is the name of your image asset for herbs
            //        case "bamboo":
            //            imageName = "bambooIcon" // Assuming "bambooIcon" is the name of your image asset for bamboo
        default:
            //            imageName = "questionMark" // Default image for unknown plant forms
            imageName = ""
        }
        return Image(imageName)
    }
    
    var iconDisplaySize: Int {
        let size: Int
        switch plantForm!.lowercased() {
        case "tree":
            size = 64
        case "shrub":
            size = 53
        case "herb":
            size = 42
        default:
            size = 40
        }
        return size
    }
}


