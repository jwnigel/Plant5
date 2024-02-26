//
//  RecommendationTitle.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 14/02/24.
//

import SwiftUI

struct RecommendationTitle: View {
    
    let title: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 50)
                .foregroundColor(Color.brandPrimary.opacity(0.1))
            Text(title)
                .font(.title)
                .foregroundColor(Color.brandSecondary)
                .fontWeight(.semibold)
                .padding(.leading, 6)
        }
    }
}

struct RecommendationTitle_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationTitle(title: "For your habitat")
    }
}
