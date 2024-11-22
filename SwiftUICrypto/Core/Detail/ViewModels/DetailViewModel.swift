//
//  DetailViewModel.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 22/11/24.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    private let coinDetailDataService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()

    init(coin: CoinModel) {
        coinDetailDataService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailDataService.$coinDetail
            .sink { coinDetail in
                
            }
            .store(in: &cancellables)
    }
}
