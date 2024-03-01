//
//  PostalCodeSuggestionView.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/14/23.
//

import SwiftUI



struct PostalCodeSuggestionView: View {
    @Binding var isPresented: Bool
    @Binding var selectedZipCode: String
    let postalCodeSuggestions: [String]

    var body: some View {
        NavigationView {
            List {
                ForEach(postalCodeSuggestions, id: \.self) { suggestion in
                    Button(action: {
                        self.selectedZipCode = suggestion
                        self.isPresented = false
                    }) {
                        Text(suggestion)
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationBarTitle("Pincode suggestions", displayMode: .large)
            .listStyle(GroupedListStyle())
        }
    }
}

