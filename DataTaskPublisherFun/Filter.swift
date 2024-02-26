//
//  Filter.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 14/02/24.
//

import SwiftUI


struct Filter: Identifiable {
    let id: UUID = UUID()
    let name: String
    var on: Bool = false
}
