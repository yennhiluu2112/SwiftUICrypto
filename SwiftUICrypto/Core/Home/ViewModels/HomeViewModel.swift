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
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers() {
        dataService.$allCoins
            .sink { [unowned self] coins in
                allCoins = coins
            }
            .store(in: &cancellables)
    }
    
}
