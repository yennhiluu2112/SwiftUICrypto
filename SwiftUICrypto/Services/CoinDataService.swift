//
//  CoinDataService.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 17/11/24.
//

import Foundation
import Combine

class CoinDataService {
    @Published var allCoins: [CoinModel] = []
 
    var coinSubscription: AnyCancellable?
    
    
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
//        let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets")!
//        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
//        let queryItems: [URLQueryItem] = [
//          URLQueryItem(name: "vs_currency", value: "usd"),
//          URLQueryItem(name: "per_page", value: "250"),
//          URLQueryItem(name: "sparkline", value: "true"),
//          URLQueryItem(name: "price_change_percentage", value: "24h"),
//        ]
//        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
//
//        var request = URLRequest(url: components.url!)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 10
//        request.allHTTPHeaderFields = [
//          "accept": "application/json",
//          "x-cg-demo-api-key": "CG-UeiPANqL1CzUKCD8kwTHS6og    "
//        ]
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }

        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [unowned self] returnCoins in
                allCoins = returnCoins
                coinSubscription?.cancel()
            }

    }
}
