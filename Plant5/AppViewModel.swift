//
//  DataTaskPublisher_ForImagesViewModel.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 12/02/24.
//

import Combine
import SwiftUI
import CoreData


class AppViewModel: ObservableObject {
    
    @Published var selectedPlant: Plant?
    
    @Published var myPalette = Palette()
    
    @Published var images: [Image] = []
    private var imageURLs: [String] = []
    
    @Published var errorForAlert: ErrorForAlert?
    
    @Published var plantDetailCardXPadding: CGFloat = 16
    @Published var plantDetailCardYPadding: CGFloat = 25
    
    @Published var lines: [Line] = []
    @Published var isDrawingModeEnabled: Bool = false

    
    var cancellables: Set<AnyCancellable> = []
    

    func addToPalette(_ plant: Plant) {
        if !myPalette.plants.contains(plant) {
            myPalette.addPlantToPalette(plant)
        } else {
            errorForAlert = ErrorForAlert(message: "\(plant.commonName) already in palette.")
        }
    }

    
    
    func updateSelectedPlant(_ plant: Plant) {
        self.selectedPlant = plant
    }
    
    
    func fetchUsageKey(for plant: Plant, completion: @escaping (Media?) -> Void) {
        let url = URL(string: "https://api.gbif.org/v1/species/match?name=\(plant.genus ?? "Juglans")%20\(plant.species ?? "nigra")")!
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Media.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { fetchCompletion in
                if case .failure(let error) = fetchCompletion {
                    print("Error: \(error)")
                    completion(nil)
                }
            }, receiveValue: { usageKey in
                completion(usageKey)
            })
            .store(in: &cancellables)
    }

    
    func getPlantGallery(for plant: Plant) {
        let url = URL(string: "https://api.gbif.org/v1/occurrence/search?taxonKey=\(plant.gbifUsageKey)&mediaType=stillImage")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .print("running dataTaskPublisher")
            .map { $0.data }
            .decode(type: Root.self, decoder: JSONDecoder())
    
            .flatMap { root -> AnyPublisher<[UIImage?], Never> in
                let imageUrls = root.results.prefix(4).compactMap { $0.extensions.multimedia.first?.identifier }.compactMap(URL.init)  // Change .prefix() to modify how many images to return
                let imagePublishers = imageUrls.map { url in
                    URLSession.shared.dataTaskPublisher(for: url)
                        .mapError { $0 as Error }
                        .map { UIImage(data: $0.data) }
                        .catch { _ in Just(nil) } // Continue on error with a nil image
                        .eraseToAnyPublisher()
                }
                // Use MergeMany correctly by spreading the array of publishers
                let mergedPublishers = Publishers.MergeMany(imagePublishers)
                    .collect() // Collects all emitted values into an array
                    .eraseToAnyPublisher()

                return mergedPublishers
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Shit: \(error)")
                    self.errorForAlert = ErrorForAlert(message: "Couldn't download a valid image")
                }
            }, receiveValue: { [unowned self] uiImages in
                let images = uiImages.compactMap { $0 }.map { Image(uiImage: $0) }
                self.images = images
                if images.isEmpty {
                    self.errorForAlert = ErrorForAlert(message: "Didn't receive any images")
                }
            })
            .store(in: &cancellables)
    }
}



struct ErrorForAlert: Error, Identifiable {
    let id = UUID()
    let title: String = "Error"
    var message: String = "Try again later"
}


struct ImageView: Identifiable {
    var id = UUID()
    var image: Image
}

// To get Usage Key

struct Media: Decodable {
    let usageKey: Int
}

// To get image URLs
struct Root: Decodable {
    let results: [Result]
}

// Define the structure of each result item
struct Result: Decodable {
    let extensions: Extensions
}

// Define the structure to match the 'extensions' object
struct Extensions: Decodable {
    let multimedia: [Multimedia]
    
    enum CodingKeys: String, CodingKey {
        case multimedia = "http://rs.gbif.org/terms/1.0/Multimedia"
    }
}

// Define the structure for multimedia items
struct Multimedia: Decodable {
    let identifier: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "http://purl.org/dc/terms/identifier"
    }
}


