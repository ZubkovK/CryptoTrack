//
//  AuthAssembly.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 11.03.2025.
//
import UIKit

final class AuthAssembly {
    
    // MARK: - Init
    
    private init() { }
    
    // MARK: - Interface
    
    static func build() -> UIViewController {
        let presenter = AuthPresenterImpl()
        let controller = AuthViewController(retain: presenter)
        presenter.view = controller
        return controller
    }
    
}
