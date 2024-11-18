//
//  CoinRowView.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 16/11/24.
//

import SwiftUI

struct CoinRowView: View {
        
    let coin: CoinModel
    let showHoldingColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if showHoldingColumn {
                centerColumn
            }
            rightColumn
            
        }
        .font(.subheadline)
    }
}

extension CoinRowView {
    private var leftColumn: some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .frame(minWidth: 30)
            Circle()
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(.theme.accent)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(.theme.accent)
            Text((coin.priceChangePercentage24H ?? 0).asPercentString())
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ? .theme.green : .theme.red )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5,
               alignment: .trailing)
    }
}

#Preview {
    Group {
        CoinRowView(coin: DeveloperPreview.instance.coin,
                    showHoldingColumn: true)
        .previewLayout(.sizeThatFits)
        
        CoinRowView(coin: DeveloperPreview.instance.coin,
                    showHoldingColumn: true)
        .previewLayout(.sizeThatFits)
        .colorScheme(.dark)
    }
}
