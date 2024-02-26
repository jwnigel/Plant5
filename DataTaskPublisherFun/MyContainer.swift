//
//  MyContainer.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 20/02/24.
//

import CoreData
import Combine

struct MyContainer {
    
    let container: NSPersistentContainer
    
    init(forPreview: Bool = false) {
        
        container = NSPersistentContainer(name: "Plant")
        
        if forPreview {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved Error: \(error)")
            }
        }
        
        if forPreview {
            addStarterData(moc: container.viewContext)
        }
    }
    
    
    static func addNewPlantExample(moc: NSManagedObjectContext) {
        
        // Adding a Plant with most but not all of the optional parameters.
        // No .images, .imageURLs, nor .gbifUsageKey, as all data from the JSON will be missing these
        
        let newPlant = Plant(context: moc)
        newPlant.latinName = "Corylus americana"
        newPlant.genus = "Corylus"
        newPlant.species = "americana"
        newPlant.family = "Betulaceae"
        newPlant.commonName = "American hazelnut"
        newPlant.rootPattern = "F"
        newPlant.hardinessZones = "3-8"
        newPlant.light = "FD"
        newPlant.height =  "15'"
        newPlant.width =  "8'"
        newPlant.soilAcidity = "Acidic, Garden, Alkaline"
        newPlant.ecosystemString = "ENA"
        try? moc.save()
        
    }
    
    
    func addStarterData(moc:NSManagedObjectContext) {
        loadAndDecodeJSON(moc: moc,
                          for: "starter_data")
    }
    

    func loadAndDecodeJSON(moc: NSManagedObjectContext, for fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("JSON file not found")
            return
        }
        
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: url)
            let plants = try decoder.decode([PlantJSONStruct].self, from: data)
            insertPlantsIntoCoreData(plants: plants, moc: moc)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }

    func insertPlantsIntoCoreData(plants: [PlantJSONStruct], moc: NSManagedObjectContext) {
        
        plants.forEach { plantStruct in
            let plantEntity = Plant(context: moc)
            plantEntity.latinName = plantStruct.latinName
            plantEntity.genus = plantStruct.genus
            plantEntity.species = plantStruct.species
            plantEntity.commonName = plantStruct.commonName
            plantEntity.family = plantStruct.family
            plantEntity.rootPattern = plantStruct.rootPattern
            plantEntity.hardinessZones = plantStruct.hardinessZones
            plantEntity.light = plantStruct.light
            plantEntity.habit = plantStruct.habit
            plantEntity.height = plantStruct.height
            plantEntity.width = plantStruct.width
            plantEntity.growthRate = plantStruct.growthRate
            plantEntity.nativeRegion = plantStruct.nativeRegion
            plantEntity.medicinal = plantStruct.medicinal
            plantEntity.nuisances = plantStruct.nuisances
            plantEntity.poison = plantStruct.poison
            plantEntity.moisture = plantStruct.moisture
            plantEntity.plantForm = plantStruct.plantForm
            plantEntity.soilAcidity = plantStruct.soilAcidity
            plantEntity.edible = plantStruct.edible
            plantEntity.edibleString = plantStruct.edibleString
            plantEntity.ecosystemString = plantStruct.ecosystemString
            
            do {
                try moc.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    
}
