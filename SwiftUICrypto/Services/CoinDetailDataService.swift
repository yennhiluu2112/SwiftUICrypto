//
//  CoinDetailDataService.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 22/11/24.
//

import Foundation
import Combine

class CoinDetailDataService {
    @Published var coinDetail: CoinDetailModel? = nil
    var coinDetailSubscription: AnyCancellable?

    let coin: CoinModel
    init(coin: CoinModel){
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinDetailSubscription = NetworkingManager
            .download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion,
                  receiveValue: { [unowned self] returnCoinDetail in
                coinDetail = returnCoinDetail
                coinDetailSubscription?.cancel()
            })
    }
}
