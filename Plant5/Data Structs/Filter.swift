//
//  Filter.swift
//  DataTaskPublisherFun
//
//  Created by Nigel Wright on 14/02/24.
//

import SwiftUI


// Define an enum to represent the selection type of boolean filters
enum SelectionType {
    case single // Radio button (only one option can be selected)
    case multiple // Checkbox button (multiple options can be selected)
}

// Define a struct to represent a boolean filter
struct BoolFilter: FilterProtocol, Identifiable {
    let id = UUID()
    let name: String
    let selectionType: SelectionType // Selection type applicable only to boolean filters
    let options: [BoolFilterOption]
}


struct BoolFilterOption: Identifiable {
    let id = UUID()
    let name: String
    @Binding var isSelected: Bool
}


// Define a struct to represent a numerical range filter
struct NumFilter: FilterProtocol, Identifiable {
    let id = UUID()
    let name: String
    let range: ClosedRange<Double>
    var value: Double // Value for numerical range filter
}

// Define an enum to represent the types of filters
enum FilterType {
    case boolean(SelectionType) // Boolean filter with selection type
    case numerical(ClosedRange<Double>) // Numerical range filter
}

// Define a protocol for filters
protocol FilterProtocol {
    var id: UUID { get }
    var name: String { get }
}

// Views for rendering filter options
struct RadioGroupView: View {
    let filter: BoolFilter
    @State private var selectedOption: String?
    
    var body: some View {
        // Implementation for single selection boolean filters
    }
}

struct CheckboxGroupView: View {
    let filter: BoolFilter
    @State private var selectedOptions: Set<String> = []
    
    var body: some View {
        // Implementation for multiple selection boolean filters
    }
}

struct NumFilterOptionView: View {
    let filter: NumFilter
    
    var body: some View {
        // Implementation for numerical range filters
    }
}
