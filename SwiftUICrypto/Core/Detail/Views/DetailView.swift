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
    @StateObject private var vm: DetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let spacing: CGFloat = 30
    
    let coin: CoinModel
    init(coin: CoinModel) {
        self.coin = coin
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("")
                        .frame(height: 150)
                    overviewTitle
                    Divider()
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    
                }
            }
            .navigationTitle(vm.coin.name)
        }
        .padding()
        
    }
}

extension DetailView {
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  content: {
            ForEach(vm.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        })
    }
    
    private var additionalTitle: some View {
        Text("Additional Value")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  content: {
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        })
    }
}

#Preview {
    DetailView(coin: DeveloperPreview.instance.coin)
}
