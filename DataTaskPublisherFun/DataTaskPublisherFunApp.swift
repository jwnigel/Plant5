//
//  DataTaskPublisherFunApp.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 12/02/24.
//

import SwiftUI
import CoreData





@main
struct DataTaskPublisherFunApp: App {

    @StateObject var appViewModel = AppViewModel()
    let container = MyContainer(forPreview: true).container
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
                .environment(\.managedObjectContext, container.viewContext)
        }
    }
}
