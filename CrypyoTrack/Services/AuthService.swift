//
//  AuthService.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 11.03.2025.
//

import Foundation


protocol AuthServiceObserver: AnyObject {
    
    func userDidLogin()
    func userDidLogout()
}

class AuthService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let credentialsKey = "authCredentials"
    }
    
    // MARK: - Weak Observer
    
    private struct WeakAuthObserver {
        weak var value: AuthServiceObserver?
    }
    
    // MARK: - Properties
    
    private let keychainService = KeychainService.shared
    private var observers = [WeakAuthObserver]()
    
    static let shared = AuthService()
    
    var isAuthenticated: Bool {
        return keychainService.load(key: Constants.credentialsKey) != nil
    }
    
    // MARK: - Init
    
    private init() { }

    // MARK: - Interface
    
    func login(login: String, password: String) -> Result<Void, Error> {
        guard login == "1234", password == "1234" else {
            let error = NSError(
                domain: "Auth",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Неверный логин или пароль"]
            )
            return .failure(error)
        }

        guard let credentialsData = "\(login):\(password)".data(using: .utf8) else {
            let error = NSError(
                domain: "Auth",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Ошибка кодирования данных"]
            )
            return .failure(error)
        }

        if keychainService.save(key: Constants.credentialsKey, data: credentialsData) {
            notifyObservers { $0.userDidLogin() }
            return .success(())
        } else {
            let error = NSError(
                domain: "Auth",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Ошибка сохранения в Keychain"]
            )
            return .failure(error)
        }
    }

    func logout() {
        keychainService.delete(key: Constants.credentialsKey)
        notifyObservers { $0.userDidLogout() }
    }

    // MARK: - Observer Management
    
    func addObserver(_ observer: AuthServiceObserver) {
        observers.append(WeakAuthObserver(value: observer))
    }

    private func notifyObservers(_ action: @escaping (AuthServiceObserver) -> Void) {
        DispatchQueue.main.async { [weak self] in
            self?.observers.forEach { observer in
                guard let observer = observer.value else { return }
                action(observer)
            }
        }
    }
}
