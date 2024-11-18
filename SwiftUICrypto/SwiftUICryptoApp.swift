//
//  SwiftUICryptoApp.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 16/11/24.
//

import SwiftUI

@main
struct SwiftUICryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .toolbar(.hidden)
            }
            .environmentObject(vm)
        }
    }
}
