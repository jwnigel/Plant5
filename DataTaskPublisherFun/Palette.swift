//
//  Palette.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 23/02/24.
//

import Foundation

struct Palette {
    
    var plants: [Plant] = []
    
    mutating func addPlantToPalette(_ plant: Plant) {
        plants.append(plant)
    }
    
}
