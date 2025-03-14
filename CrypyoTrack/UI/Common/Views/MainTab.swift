//
//  Tab.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 14.03.2025.
//

enum MainTab: Int, CaseIterable {
    case home
    case tab2
    case tab3
    case tab4
    case tab5
    
    var iconName: String {
        switch self {
        case .home:
            "home"
        case .tab2:
            "stonks"
        case .tab3:
            "wallet"
        case .tab4:
            "receipt"
        case .tab5:
            "user"
        }
    }
}
