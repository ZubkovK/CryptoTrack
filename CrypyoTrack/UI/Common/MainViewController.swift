//
//  MainViewController.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 13.03.2025.
//

import UIKit
import SnapKit

protocol MainViewControllerDelegate: AnyObject {
    
    func didSelectTab(_ newTab: MainTab)
    
}

final class MainViewController: UIViewController {
    
    // MARK: - Views
    
    weak var delegate: MainViewControllerDelegate?
    
    private lazy var tabBar: TabBar = {
        let tabBar = TabBar()
        tabBar.delegate = self
        return tabBar
    }()
    
    private var contentController: UIViewController?
    private var contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    func setController(_ viewController: UIViewController) {
        if let oldController = contentController {
            oldController.willMove(toParent: nil)
            oldController.view.removeFromSuperview()
            oldController.removeFromParent()
        }
        
        addChild(viewController)
        contentView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        viewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupUI() {
        view.addSubview(contentView)
        view.addSubview(tabBar)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
        }
        
        tabBar.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
}



extension MainViewController: TabBarDelegate {
    
    // MARK: - TabBarDelegate
    
    func didSelectTab(_ newTab: MainTab) {
        delegate?.didSelectTab(newTab)
    }
    
}
