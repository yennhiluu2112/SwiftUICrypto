//
//  CoinImageViewModel.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 18/11/24.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: CoinModel
    private let dataService: CoinImageService
    private var cancellable = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        addSubscriber()
    }
    
    private func addSubscriber(){
        dataService.$coinImage
            .sink { [unowned self] _ in
                isLoading = false
            } receiveValue: { [unowned self] coinImage in
                image = coinImage
            }
            .store(in: &cancellable)
    }
}
