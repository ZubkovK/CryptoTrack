//
//  CoinListPresenter.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 11.03.2025.
//

import Foundation

final class CoinListPresenterImpl {
    
    //MARK: - Properties
    
    weak var view: CoinListView? {
        
        didSet {
            setupViewCallbacks()
        }
    }
    
    private let networkService = NetworkService.shared
    private var coins = [Coin]()
    private let router: CoinListRouter
    private var isSortDesc = true
    
    // MARK: - Init
    
    init(router: CoinListRouter) {
        self.router = router
    }
    
    // MARK: - Private Methods
    
    private func setupViewCallbacks() {
        view?.onViewDidLoad = { [weak self] in
            self?.view?.beginRefreshing()
            self?.fetchCoins()
        }
        
        view?.onCoinSelected = { [weak self] id in
            guard
                let self,
                let coin = self.coins.first(where: { $0.id == id })
            else { return }
            
            self.router.showCoinDetails(with: coin)
        }
        
        view?.onSortTapped = { [weak self] in
            self?.changeSorting()
        }
        
        view?.onLogoutTapped = { [weak self] in
            self?.logout()
        }
        
        view?.onReloadTapped = { [weak self] in
            self?.reload()
        }
    }
    
    private func fetchCoins() {
        networkService.fetchCoin { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let coins):
                if self.isSortDesc {
                    self.coins = coins.sorted(by: { $0.marketData?.priceUsd ?? 0 > $1.marketData?.priceUsd ?? 0 })
                } else {
                    self.coins = coins.sorted(by: { $0.marketData?.priceUsd ?? 0 < $1.marketData?.priceUsd ?? 0 })
                }
                self.updateView()
                self.view?.endRefreshing()
            case .failure(let error):
                print("Ошибка загрузки данных: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateView() {
        let cointModels = coins.map {
            CoinCellModel(
                id: $0.id,
                name: $0.name,
                symbol: $0.symbol,
                imageName: $0.slug?.imageName,
                price: $0.marketData?.priceUsd,
                percentageChange: $0.marketData?.percentChange24hours
            )
        }
        let viewModel = CoinListViewModel(coinViewModels: cointModels)
        self.view?.display(viewModel: viewModel)
    }
    
    private func changeSorting() {
        isSortDesc.toggle()
        reload()
    }
    
    private func reload() {
        view?.beginRefreshing()
        fetchCoins()
        coins = []
        updateView()
    }
    
    private func logout() {
        AuthService.shared.logout()
    }
    
}
