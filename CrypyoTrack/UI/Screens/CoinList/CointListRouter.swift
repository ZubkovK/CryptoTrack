//
//  CointListRouter.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 13.03.2025.
//

import UIKit

protocol CoinListRouter {
    func showCoinDetails(with coin: Coin)
}

final class CoinListRouterImpl: CoinListRouter {
    
    // MARK: - Properties
    
    weak var viewController: UIViewController?
    
    // MARK: - Interface
    
    func showCoinDetails(with coin: Coin) {
        let coinDetailsController = CoinDetailAssembly.build(coin: coin)
        viewController?.navigationController?.pushViewController(
            coinDetailsController,
            animated: true
        )
    }
    
}
