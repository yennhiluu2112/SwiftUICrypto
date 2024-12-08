//
//  CoinImageService.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 18/11/24.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var coinImage: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            coinImage = savedImage
            print("Retrieved image from File Manager")
        } else {
            downloadCoinImage()
            print("Downloading image now")
        }
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else { return }

        imageSubscription = NetworkingManager
            .download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion,
                  receiveValue: { [unowned self] returnImage in
                guard let returnImage else { return }
                coinImage = returnImage
                imageSubscription?.cancel()
                fileManager.saveImage(image: returnImage, imageName: imageName, folderName: folderName)
            })
    }
}
