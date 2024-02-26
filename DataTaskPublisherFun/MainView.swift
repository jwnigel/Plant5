

import SwiftUI
import Foundation

struct MainView: View {
    
    @Environment(\.managedObjectContext) private var moc                        //
    @EnvironmentObject var viewModel: AppViewModel
    
    @FetchRequest(sortDescriptors: []) var plants: FetchedResults<Plant>
    
    @State var isShowingDetailView = false
    
    
    @State private var searchText: String
    
    @State private var resultsViewStyle: ResultsViewStyle = .listView
    
    @State private var filterUses: Filter
    @State private var filterForm: Filter
    @State private var filterHabit: Filter
    @State private var filterZone: Filter
    @State private var filterSize: Filter
    @State private var filterLight: Filter
    @State private var filters: [Filter]
    
    
    var filteredPlants: [Plant] {
        if searchText.isEmpty {
            return Array(plants)
        } else {
            return plants.filter { plant in
                plant.commonName?.localizedCaseInsensitiveContains(searchText) == true ||
                plant.latinName?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }
    
    
    init() {
        self._searchText = State(initialValue: "")
        self._filterUses = State(initialValue: Filter(name: "Uses"))
        self._filterForm = State(initialValue: Filter(name: "Plant Form"))
        self._filterHabit = State(initialValue: Filter(name: "Habit"))
        self._filterZone = State(initialValue: Filter(name: "Zone"))
        self._filterSize = State(initialValue: Filter(name: "Size"))
        self._filterLight = State(initialValue: Filter(name: "Light"))
        self._filters = State(initialValue: [Filter(name: "Plant Form"), Filter(name: "Habit"), Filter(name: "Uses"), Filter(name: "Hardiness Zone"), Filter(name: "Size"), Filter(name: "Light")])
        
    }
    
       
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(filters) { filter in
                                FilterCard(filterName: filter.name)
                                    .onTapGesture {
                                        // Handle the tap gesture here
                                        // For example, you might want to update the search based on the selected filter
                                        print("Filter \(filter.name) tapped")
                                    }
                            }
                        }
                    }
                    .padding(.top, 6)
                    
                    ForEach(filteredPlants) { plant in
                        PlantListCard(plant: plant)
                            .padding(.horizontal, 8)
                            .onTapGesture {
                                isShowingDetailView = true
                                viewModel.updateSelectedPlant(plant)
                                print("Selected plant is \(viewModel.selectedPlant?.commonName)")
                            }
                    }
                }
                
                .background(Color.brandPrimary.opacity(0.9).ignoresSafeArea(.all))
                .padding(.top, -8)
            }
            .onAppear {
    
                viewModel.updateSelectedPlant(plants.first!)
                
                if let selectedPlant = viewModel.selectedPlant {
                    viewModel.fetchUsageKey(for: selectedPlant) { media in
                        if let media = media {
                            // Update the plant with the received usage key
                            DispatchQueue.main.async {
                                selectedPlant.gbifUsageKey = Int64(media.usageKey)
                                // Handle any necessary UI updates
                                viewModel.getPlantGallery(for: selectedPlant)
                                //                            viewModel.selectedPlant?.images = viewModel.images
                            }
                        } else {
                            // Handle the error case, such as showing an alert to the user
                            viewModel.errorForAlert = ErrorForAlert(message: "Couldn't fetch media for selectedPlant \(selectedPlant)")
                        }
                    }
                }
                
            }
            .blur(radius: isShowingDetailView ? 20 : 0)
            
            .searchable(text: $searchText, prompt: "Find Plants")
            
            if isShowingDetailView {
                PlantDetailCard(plant: viewModel.selectedPlant!)
                    .shadow(radius: 40)
                    .overlay(

                        VStack {
                            Button(action: {
                                isShowingDetailView = false
                            }) {
                                XDismissButton()
                            }
                            .padding(.top, viewModel.plantDetailCardYPadding + 3)
                            .padding(.trailing, viewModel.plantDetailCardXPadding + 3)
                            Spacer()
                        },
                        alignment: .topTrailing
                    )
            }
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}



enum ResultsViewStyle: String {
    case listView
    case deckView
}
