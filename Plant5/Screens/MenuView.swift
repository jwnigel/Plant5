//
//  MenuView.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 21/02/24.
//

import SwiftUI

struct MenuView: View {
    @AppStorage("selectedMenu") var selectedMenu: MainMenu = .findPlants
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List(navigationItems) { item in
            Button {
                selectedMenu = item.menu
                presentationMode.wrappedValue.dismiss()
            } label: {
                Label(item.title, systemImage: item.icon)
                    .foregroundColor(.primary)
                .padding(8)
            }
        }
        .listStyle(.plain)
    }
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
