//
//  Plant+Ext.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 22/02/24.
//

import CoreData



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




