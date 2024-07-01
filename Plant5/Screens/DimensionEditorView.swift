//
//  DimensionEditorView.swift
//  Plant5
//
//  Created by Nigel Wright on 03/03/24.
//

import SwiftUI

struct DimensionEditorView: View {
    @Environment(\.dismiss) var dismiss
        
    @Binding var width: Double
    @Binding var height: Double
    
    var body: some View {
        VStack {
            XDismissButton()
                .onTapGesture {
                    dismiss()
                }
            Form {
                TextField("Width", value: $width, format: .number)
                    .keyboardType(.decimalPad)
                TextField("Height", value: $height, format: .number)
                    .keyboardType(.decimalPad)
            }
        }
    }
}

struct DimensionEditorView_Previews: PreviewProvider {
    static var previews: some View {
        DimensionEditorView(width: .constant(1000), height: .constant(1000))
    }
}
