//
//  StatisticView.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 19/11/24.
//

import SwiftUI

struct StatisticView: View {
    
    let stat: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
            
            Text(stat.value)
                .font(.headline)
                .foregroundColor(.theme.accent)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(.degrees((stat.percentageChange ?? 0) >= 0 ? 0 : 180))
                
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor((stat.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0 : 1)


        }
    }
}

#Preview {
    Group {
        StatisticView(stat: DeveloperPreview.instance.stat1)
        StatisticView(stat: DeveloperPreview.instance.stat2)
        StatisticView(stat: DeveloperPreview.instance.stat3)
    }
}
