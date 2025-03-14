//
//  CoinListAssembly.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 11.03.2025.
//

import UIKit

final class CoinListAssembly {

    // MARK: - Init
    
    init() {}
    
    //MARK: - Inetface
    
    static func build() -> UIViewController {
        let router = CoinListRouterImpl()
        let presenter = CoinListPresenterImpl(router: router)
        let controller = CoinListViewController(retain: presenter)
        presenter.view = controller
        router.viewController = controller
        return controller
    }
}
