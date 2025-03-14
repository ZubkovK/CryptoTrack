//
//  NetworkService.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 12.03.2025.
//

import Foundation



class NetworkService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let baseURL = "https://data.messari.io/api/v1/assets"
        static let prefixMetric = "/metrics"
    }
    
    // MARK: - Properties
    
    var errors: [Error] = []
    static let shared = NetworkService()
    
    // MARK: - Init
    
    private init() { }
    
    // MARK: - Interface
    
    func fetchCoin(completion: @escaping (Result<[Coin], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var results: [Coin] = []
        var errors: [Error] = []
        
        for symbol in CoinType.allCases {
            dispatchGroup.enter()
            
            let urlSting = "\(Constants.baseURL)/\(symbol.request)\(Constants.prefixMetric)"
            guard let url = URL(string: urlSting) else {
                dispatchGroup.leave()
                continue
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                defer { dispatchGroup.leave() }
                
                if let error = error {
                    print("Network error for symbol \(symbol): \(error)")
                    errors.append(error)
                    return
                }
                
                guard let data = data else {
                    print("No data received for symbol \(symbol)")
                    return
                }
                
                do {
                    let coinData = try JSONDecoder().decode(CoinResponse.self, from: data)
                    results.append(coinData.coin)
                } catch {
                    print("Error decoding data for symbol \(symbol): \(error)")
                    errors.append(error)
                }
            }
            task.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            if let error = errors.first {
                completion(.failure(error))
            } else {
                completion(.success(results))
            }
        }
    }
}

