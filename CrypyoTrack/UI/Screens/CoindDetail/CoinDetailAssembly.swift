//
//  CoinDetailAssembly.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 13.03.2025.
//
import UIKit

final class CoinDetailAssembly {
    
    // MARK: - Init
    
    private init() { }
    
    // MARK: - Interface
    
    static func build(coin: Coin) -> UIViewController {
        let presenter = CoinDetailPresenterImp(coin: coin)
        let controller = CoinDetailViewController(retain: presenter)
        presenter.view = controller
        return controller
        
    }
    
    
}
