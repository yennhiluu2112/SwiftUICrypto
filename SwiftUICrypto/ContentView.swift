//
//  ContentView.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 16/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.red.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Accent Color")
                    .foregroundColor(.theme.accent)
                Text("Green Color")
                    .foregroundColor(.theme.green)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
