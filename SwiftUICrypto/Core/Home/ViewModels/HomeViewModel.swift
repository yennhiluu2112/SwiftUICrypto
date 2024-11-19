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
    @Published var statistics: [StatisticModel] = [
        StatisticModel(title: "Title", value: "Value", percentageChange: 1),
        StatisticModel(title: "Title", value: "Value"),
        StatisticModel(title: "Title", value: "Value"),
        StatisticModel(title: "Title", value: "Value", percentageChange: -7)

    ]
    
    private let dataService = CoinDataService()
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
        // update allcoins
        $searchText
             .combineLatest(dataService.$allCoins) // call when either update
             .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // delay 0.5s 
             .map(filterCoins)
             .sink { [unowned self] coins in
                 allCoins = coins
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
    
}
