//
//  Coin.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 13.03.2025.
//

import Foundation

struct CoinResponse: Codable {
    let coin: Coin
    
    enum CodingKeys: String, CodingKey {
        case coin = "data"
    }
    
}

struct Coin: Codable {
    let id: UUID
    let serialId: Int?
    let symbol: String?
    let name: String?
    let slug: CoinType?
    let internalTempAgoraIid: String?
    let marketData: MarketData?
    let roiData: RoiData?
    let marketcap: MarketCap?
    let supply: Supply?
 

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case serialId = "serial_id"
        case symbol = "symbol"
        case name = "name"
        case slug = "slug"
        case internalTempAgoraIid = "_internal_temp_agora_id"
        case marketData = "market_data"
        case roiData = "roi_data"
        case marketcap
        case supply
    }
}

struct MarketData: Codable {
    let priceUsd: Decimal?
    let percentChange24hours: Double?
    
    enum CodingKeys: String, CodingKey {
        case priceUsd = "price_usd"
        case percentChange24hours = "percent_change_usd_last_24_hours"
    }
    
}

struct RoiData: Codable {
    
    let percentChangeLastWeek: Double?
    let percentChangeLastMonth: Double?
    let percentChangeLast3Months: Double?
    let percentChangeLastYear: Double?
    
    enum CodingKeys: String, CodingKey {
        case percentChangeLastWeek = "percent_change_last_1_week"
        case percentChangeLastMonth = "percent_change_last_1_month"
        case percentChangeLast3Months = "percent_change_last_3_months"
        case percentChangeLastYear = "percent_change_last_1_year"
    }
}

struct MarketCap: Codable {
    let rank: Int
    let marketCapUsd: Decimal
    
    enum CodingKeys: String, CodingKey {
        case rank
        case marketCapUsd = "current_marketcap_usd"
    }
    
}

struct Supply: Codable {
    let circulating: Double
}

enum CoinType: String, CaseIterable, Codable {
    case btc = "bitcoin"
    case eth = "ethereum"
    case tron
    case luna = "luna-by-virtuals"
    case polkadot
    case dogecoin
    case tether
    case stellar
    case cardano
    case xrp
    case neo
    case act = "act-i-the-ai-prophecy"
    
    var request: String {
        switch self {
        case .btc:
            "btc"
        case .luna:
            "luna"
        case .eth:
            "eth"
        case .act:
            "act"
        default:
            rawValue
        }
    }
    
    var imageName: String? {
        switch self {
        case .btc:
            "btc"
        case .neo:
            "neo"
        case .act:
            "act"
        default:
            nil
        }
    }
}
