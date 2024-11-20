//
//  HomeViewModel.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 17/11/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var statistics: [StatisticModel] = []
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers() {
//        dataService.$allCoins
//            .sink { [unowned self] coins in
//                allCoins = coins
//            }
//            .store(in: &cancellables)
//        

        // update coins data
        $searchText
             .combineLatest(coinDataService.$allCoins) // call when either update
             .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // delay 0.5s 
             .map(filterCoins)
             .sink { [unowned self] coins in
                 allCoins = coins
             }            
             .store(in: &cancellables)
        
        // update market data
        marketDataService
            .$marketData
            .map(mapGlobalMarketData)
            .sink { [unowned self] stats in
                statistics = stats
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return coins }
        let lowercaseText = text.lowercased()
        
        let filteredCoins = coins.filter {
            $0.name.lowercased().contains(lowercaseText)
            || $0.symbol.lowercased().contains(lowercaseText)
            || $0.id.lowercased().contains(lowercaseText)
        }
        
        return filteredCoins
    }
    
    private func mapGlobalMarketData(marketData: MarketDataModel?) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketData else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap",
                                       value: data.marketCap,
                                       percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.0", percentageChange: 0)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }
    
}
