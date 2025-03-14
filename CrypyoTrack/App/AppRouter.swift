//
//  AppRouter.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 11.03.2025.
//

import UIKit

enum Screen {
    case auth
    case coinList
    case tab2
    case tab3
    case tab4
    case tab5
}

final class AppRouter {
    
    // MARK: - Properties
    
    static var shared: AppRouter {
        if let _shared {
            return _shared
        } else {
            fatalError("Need to call \"make\" method")
        }
    }
    
    private static var _shared: AppRouter?
    private weak var window: UIWindow?
    
    private lazy var mainController = {
        let mainController = MainViewController()
        mainController.delegate = self
        return mainController
    }()
    
    // MARK: - Init
    
    private init(window: UIWindow?) {
        self.window = window
        AuthService.shared.addObserver(self)
    }
    
    // MARK: - Configuration
    
    static func make(with window: UIWindow?) {
        _shared = AppRouter(window: window)
    }
    
    // MARK: - Interface
    
    func set(screen: Screen, animated: Bool = true) {
        let viewController = makeViewController(for: screen)
        switchRoot(to: viewController, animated: animated)
    }
    
    // MARK: - Private methods
    
    private func makeViewController(for screen: Screen) -> UIViewController {
        switch screen {
        case .auth:
            return AuthAssembly.build()
        case .coinList:
            let coinListViewController = CoinListAssembly.build()
            let navController = UINavigationController(rootViewController: coinListViewController)
            mainController.setController(navController)
            return mainController
        case .tab2, .tab3, .tab4, .tab5:
            mainController.setController(placeholderController(for: screen))
            return mainController
        }
    }
    
    private func placeholderController(for screen: Screen) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        vc.title = String(describing: screen).capitalized
        return UINavigationController(rootViewController: vc)
    }
    
    private func switchRoot(to controller: UIViewController, animated: Bool) {
        guard let window = window else { return }
        
        if animated {
            UIView.transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: { window.rootViewController = controller },
                completion: nil
            )
        } else {
            window.rootViewController = controller
        }
    }
}

extension AppRouter: AuthServiceObserver {
    
    // MARK: - AuthServiceObserver
    
    func userDidLogin() {
        set(screen: .coinList)
    }
    
    func userDidLogout() {
        set(screen: .auth)
    }
    
}

extension AppRouter: MainViewControllerDelegate {
    
    // MARK: - MainViewControllerDelegate
    
    func didSelectTab(_ newTab: MainTab) {
        switch newTab {
        case .home:
            set(screen: .coinList)
        case .tab2:
            set(screen: .tab2)
        case .tab3:
            set(screen: .tab3)
        case .tab4:
            set(screen: .tab4)
        case .tab5:
            set(screen: .tab5)
        }
    }
    
}
