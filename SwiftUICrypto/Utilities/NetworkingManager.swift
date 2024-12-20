//
//  NetworkingManager.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 18/11/24.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(let url):
                return "[🔥] Bad Response from URL. \(url)"
            case .unknown:
                return "Unknown error occured"
                
            }
        }
    }
        
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
//            .subscribe(on: DispatchQueue.global(qos: .default)): always auto go to background
            .tryMap{ try handleURLResponse(output: $0, url: url) }
//            .receive(on: DispatchQueue.main) : go to main after decode
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            print(output.response)
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
        
    }
}
