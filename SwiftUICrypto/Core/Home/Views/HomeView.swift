//
//  HomeView.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 16/11/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = true //animate right
    @State private var showPortfolioView: Bool = false //show new sheet
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    @State private var showSettingView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                    .sheet(isPresented: $showPortfolioView, content: {
                        PortfolioView()
                            .environmentObject(vm)
                    })
            
                VStack {
                    homeHeader
                    HomeStatView(showPortfolio: $showPortfolio)
                    SearchBarView(searchText: $vm.searchText)
                    columnTitles
                    
                    if !showPortfolio {
                        allCoinsList
                        .transition(.move(edge: .leading))
                    } else {
                        ZStack(alignment: .top) {
                            if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                                portfolioEmptyText
                            } else {
                                portfolioCoinsList
                            }
                        }
                        .transition(.move(edge: .trailing))
                    }
                    Spacer(minLength: 0)
                }
            }
            .sheet(isPresented: $showSettingView, content: {
                SettingView()
            })
            .navigationTitle("")
            .navigationDestination(isPresented: $showDetailView,
                                   destination: { DetailLoadingView(coin: $selectedCoin) })
        }
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin,
                            showHoldingColumn: true)
                .onTapGesture {
                    segue(coin: coin)
                }
                .listRowInsets(.init(top: 10,
                                     leading: 0,
                                     bottom: 10,
                                     trailing: 10))
                .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin,
                            showHoldingColumn: true)
                .onTapGesture {
                    segue(coin: coin)
                }
                .listRowInsets(.init(top: 10,
                                     leading: 0,
                                     bottom: 10,
                                     trailing: 10))
                .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles: some View {
        HStack {
            HStack (spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity( (vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1 : 0 )
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holding")
                    Image(systemName: "chevron.down")
                        .opacity( (vm.sortOption == .holding || vm.sortOption == .holdingReversed) ? 1 : 0 )
                        .rotationEffect(Angle(degrees: vm.sortOption == .holding ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holding ? .holdingReversed : .holding
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity( (vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1 : 0 )
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5,
                                        alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0),
                            anchor: .center)

        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }
    
    private func segue(coin: CoinModel){
        selectedCoin = coin
        showDetailView = true
    }
    
    private var portfolioEmptyText: some View {
        Text("You haven't added any coins to your portfolio yet. Click the + button to get started! 🧐")
            .font(.callout)
            .foregroundColor(.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
}


#Preview {
    HomeView()
        .toolbar(.hidden)
        .environmentObject(DeveloperPreview.instance.homeVM)
}
