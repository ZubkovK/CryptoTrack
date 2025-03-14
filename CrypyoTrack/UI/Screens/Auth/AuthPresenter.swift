//
//  AuthPresenter.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 11.03.2025.
//

final class AuthPresenterImpl {
    
    // MARK: - Properties
    
    weak var view: AuthView? {
        didSet {
            setupViewCallbacks()
        }
    }
    
    private let authService = AuthService.shared
    
    // MARK: - Private Methods
    
    private func setupViewCallbacks() {
        view?.onLoginTapped = { [weak self] credentials in
            self?.handleLogin(credentials: credentials)
        }
    }
    
    private func handleLogin(credentials: (login: String?, password: String?)) {
        guard let login = credentials.login,
              let password = credentials.password,
              !login.isEmpty,
              !password.isEmpty else {
            view?.showError(message: "Заполните все поля")
            return
        }
        
        let result = authService.login(login: login, password: password)
        switch result {
        case .success:
            break
        case.failure(let error):
            view?.showError(message: error.localizedDescription)
        }
    }
    
}

