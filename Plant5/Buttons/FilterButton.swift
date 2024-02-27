//
//  FilterCard.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 14/02/24.
//

import SwiftUI

struct FilterButton: View {
    
    let filterName: String
    
    var body: some View {
        Text(filterName)
            .fontWeight(.semibold)
            .foregroundColor(.brandLight)
            .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .foregroundColor(.brandAccent)
            )
        
    }
}

struct FilterCard_Previews: PreviewProvider {
    static var previews: some View {
        FilterButton(filterName: "Uses")
    }
}
