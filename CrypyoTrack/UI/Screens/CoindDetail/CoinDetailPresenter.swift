//
//  CoinDetailPresenterImp.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 13.03.2025.
//

enum PercetageState: Int, CaseIterable {
    case day
    case week
    case year
    case all
    case point
    
    var title: String {
        switch self {
        case .day:
            "24H"
        case .week:
            "1W"
        case .year:
            "1Y"
        case .all:
            "ALL"
        case .point:
            "Point"
        }
    }
}

final class CoinDetailPresenterImp {
    
    // MARK: - Properties
    
    weak var view: CoinDetailView? {
        didSet {
            setupViewCallbacks()
        }
    }
    
    private let coin: Coin
    private var percentageState = PercetageState.day
    
    // MARK: - Init
    
    init(coin: Coin) {
        self.coin = coin
    }
    
    // MARK: - Private Methods
    
    private func setupViewCallbacks() {
        view?.onViewDidLoad = { [weak self] in
            self?.updateView()
        }
        
        view?.onPercetageStateSelected = { [weak self] newState in
            self?.percentageState = newState
            self?.updateView()
        }
    }
    
    private func updateView() {
        let percent: Double
        
        switch percentageState {
        case .day:
            percent = coin.marketData?.percentChange24hours ?? 0.0
        case .week:
            percent = coin.roiData?.percentChangeLastWeek ?? 0.0
        case .year:
            percent = coin.roiData?.percentChangeLastYear ?? 0.0
        case .all:
            percent = 0.0
        case .point:
            percent = 0.0
        }
        
        let viewModel = CoinDetailViewModel(
            title: "\(coin.name ?? "") (\(coin.symbol ?? ""))",
            usdPrice: coin.marketData?.priceUsd,
            percent: percent,
            circulating: coin.supply?.circulating ?? 0.0,
            marketCapUsd: coin.marketcap?.marketCapUsd ?? 0.0,
            symbol: coin.symbol ?? ""
        )
        view?.display(with: viewModel)
    }
}
