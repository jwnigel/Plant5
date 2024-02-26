//
//  Plant.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 17/02/24.
//

import SwiftUI
import CoreData


class PlantJSONStruct: Codable {
//    var gbifUsageKey: Int64? //gbif is the api
//    var images: [ImageModel] = []
    let latinName: String
    let genus: String
    let species: String
    let commonName: String
    let family: String
    let rootPattern: String?
    let hardinessZones: String?
    let light: String?
    let habit: String?
    let height: String?
    let width: String?
    let growthRate: String?
    let nativeRegion: String?
    let medicinal: String?
    let nuisances: String?
    let poison: String?
    let moisture: String?
    let plantForm: String?
    let soilAcidity: String?
    let edible: Bool
    let edibleString: String?
    let ecosystemString: String?
}


struct ImageModel: Codable {
    var imageData: Data?
    
}
