//
//  HomeStatView.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 19/11/24.
//

import SwiftUI

struct HomeStatView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(vm.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortfolio ? .trailing : .leading)
    }
}

#Preview {
    HomeStatView(showPortfolio: .constant(false))
        .environmentObject(DeveloperPreview.instance.homeVM)
}
