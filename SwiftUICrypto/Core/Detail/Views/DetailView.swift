//
//  DetailView.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 22/11/24.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    var body: some View {
        ZStack {
            if let coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
    }
    
    var body: some View {
        ZStack {
            Text(coin.name)
        }
    }
}

#Preview {
    DetailView(coin: DeveloperPreview.instance.coin)
}
