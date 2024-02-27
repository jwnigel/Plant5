//
//  Data.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 21/02/24.
//

import Foundation


enum MainMenu: String {
    case findPlants
    case palette
    case canvas
    case myDesign
    case settings
}

struct NavigationItem: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var icon: String
    var menu: MainMenu
}

var navigationItems = [
    NavigationItem(title: "Find Plants", icon: "magnifyingglass", menu: .findPlants),
    NavigationItem(title: "My Palette", icon: "paintpalette", menu: .palette),
    NavigationItem(title: "My Canvas", icon: "paintbrush.pointed", menu: .canvas),
    NavigationItem(title: "Design Details", icon: "squareshape.split.3x3", menu: .myDesign),
    NavigationItem(title: "Settings", icon: "gearshape", menu: .settings)
]
