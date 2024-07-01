

import SwiftUI
import Foundation

struct PlantListSearchView: View {
    
    @Environment(\.managedObjectContext) private var moc                        //
    @EnvironmentObject var viewModel: AppViewModel
    
    @FetchRequest(sortDescriptors: []) var plants: FetchedResults<Plant>
    
    @State var isShowingDetailView = false
    
    @State private var selectedFilter: Filter?
    @State private var isShowingFilterSheet = false
    
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
        self._filterUses = State(initialValue: Filter(name: "Uses", optionNames: []))
        self._filterForm = State(initialValue: Filter(name: "Plant Form", optionNames: ["Tree", "Shrub", "Herb", "Vine", "Bamboo"]))
        self._filterHabit = State(initialValue: Filter(name: "Habit", optionNames: []))
        self._filterZone = State(initialValue: Filter(name: "Zone", optionNames: []))
        self._filterSize = State(initialValue: Filter(name: "Size", optionNames: []))
        self._filterLight = State(initialValue: Filter(name: "Light", optionNames: []))
        self._filters = State(initialValue: [Filter(name: "Plant Form", optionNames: ["Tree", "Shrub", "Herb", "Vine", "Bamboo"]),
                                             Filter(name: "Habit", optionNames: []),
                                             Filter(name: "Uses", optionNames: []),
                                             Filter(name: "Hardiness Zone", optionNames: []),
                                             Filter(name: "Size", optionNames: []),
                                             Filter(name: "Light", optionNames: [])])
    }
    
       
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(filters) { filter in
                                FilterButton(filterName: filter.name)
                                    .onTapGesture {
                                        selectedFilter = filter
                                        isShowingFilterSheet = true
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
                .sheet(isPresented: $isShowingFilterSheet) {
                    VStack {
                        Text(selectedFilter?.name ?? "")
                            .fontWeight(.semibold)
                        
                        ForEach(selectedFilter?.optionNames ?? ["Filter 1", "Filter 2"], id: \.self) { filterOption in
                            Text(filterOption ?? "")
                        }
                        .padding()

                    }
                    .presentationDetents([.medium])
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
        PlantListSearchView()
    }
}



enum ResultsViewStyle: String {
    case listView
    case deckView
}
