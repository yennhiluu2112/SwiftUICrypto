//
//  SearchBarView.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 19/11/24.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? .theme.secondaryText : .theme.accent)
            TextField("Search by name or symbol...", text: $searchText)
                .foregroundColor(.theme.accent)
                .autocorrectionDisabled(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(.theme.accent)
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .onTapGesture {
                            UIApplication.shared.endEditting() //unfocus
                            searchText = ""
                        }
                    , alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: .theme.accent.opacity(0.15),
                        radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/,
                        x: 0,
                        y: 0)
            
        )
        .padding()
    }
}

#Preview {
    Group {
        SearchBarView(searchText: .constant(""))
            .previewLayout(.sizeThatFits)
            .colorScheme(.light)
        SearchBarView(searchText: .constant(""))
            .previewLayout(.sizeThatFits)
            .colorScheme(.dark)
    }
}
