//
//  Decimal+Currency.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 14.03.2025.
//

import Foundation

extension Decimal {
    
    func formatMoney() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSDecimalNumber(decimal: self))
    }
    
}
