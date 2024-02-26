//
//  ContentView.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 21/02/24.
//


import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @State var showMenu = false
    @AppStorage("selectedMenu") var selectedMenu: MainMenu = .findPlants
    @GestureState var press = false
    
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .updating($press) { currentState, gestureState, transaction in
                gestureState = currentState
            }
            .onEnded { value in
                showMenu = true
            }
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            switch selectedMenu {
                
            case .findPlants:
                MainView()
            case .palette:
                PaletteView()
            case .canvas:
                CanvasDesignView()
            case .myDesign:
                Text("Design View")
            case .settings:
                Text("Settings View")
            }
        }
        .onTapGesture {}
        .gesture(longPress)
        .sheet(isPresented: $showMenu) {
            MenuView()
                .presentationDetents([.medium, .large])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




