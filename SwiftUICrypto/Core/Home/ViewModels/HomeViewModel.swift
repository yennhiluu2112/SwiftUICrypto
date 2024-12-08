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
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holding

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holding, holdingReversed, price, priceReversed
    }
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers() {
        // update coins data
        $searchText
             .combineLatest(coinDataService.$allCoins, $sortOption) // call when either update
             .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // delay 0.5s
             .map(filterAndSortCoins)
             .sink { [unowned self] coins in
                 allCoins = coins
             }
             .store(in: &cancellables)
        
        // update portfolio coins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [unowned self] returnedCoins in
                portfolioCoins = sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        // update market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [unowned self] stats in
                statistics = stats
                isLoading = false
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sortOption: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sortOption, coins: &updatedCoins)
        return updatedCoins
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
    
    //use coins for input and return: reference type
    private func sortCoins(sort: SortOption, coins: inout [CoinModel])  {
        switch sort {
        case .rank, .holding:
            coins.sort { $0.rank < $1.rank}
        case .rankReversed, .holdingReversed:
            coins.sort { $0.rank > $1.rank}
        case .price:
            coins.sort { $0.currentPrice > $1.currentPrice}
        case .priceReversed:
            coins.sort { $0.currentPrice < $1.currentPrice}
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        //only sort by holding/ holding reversed if needed
        switch sortOption {
        case .holding:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
        
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioCoins: [PortfolioEntity]) -> [CoinModel] {
        return allCoins.compactMap { coin -> CoinModel? in
            guard let entity = portfolioCoins.first(where: { $0.coinID == coin.id })
            else { return nil }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func mapGlobalMarketData(marketData: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketData else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap",
                                       value: data.marketCap,
                                       percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume",
                                    value: data.volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance",
                                          value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map { $0.currentHoldingsValue }
            .reduce(0, +)
        
        let previousValue = portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = StatisticModel(title: "Portfolio Value",
                                       value: portfolioValue.asCurrencyWith2Decimals(),
                                       percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
}
