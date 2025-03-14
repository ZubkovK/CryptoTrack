//
//  TabBar.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 13.03.2025.
//

import UIKit

protocol TabBarDelegate: AnyObject {
    func didSelectTab(_ newTab: MainTab)
}

final class TabBar: UIView {
    
    // MARK: - Properties
    
    weak var delegate: TabBarDelegate?
    
    private var selectedTab = MainTab.home
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hex: "FFFFFF")
        setupUI()
        setupConstraints()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        addSubview(buttonsStackView)
    }
    
    private func setupConstraints() {
        buttonsStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(44)
            make.top.equalToSuperview().offset(29)
            make.height.equalTo(24)
        }
    }
    
    private func setupButtons() {
        buttonsStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
        
        for tab in MainTab.allCases {
            let button = UIButton()
            let image = UIImage(named: tab.iconName)?.withRenderingMode(.alwaysTemplate)
            button.setImage(image, for: .normal)
            button.tintColor = tab == selectedTab ? UIColor(hex: "#26273C") : UIColor(hex: "#CED0DE")
            button.tag = tab.rawValue
            button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - User Actions
    
    @objc
    private func buttonTapped(_ sender: UIButton) {
        selectedTab = MainTab(rawValue: sender.tag) ?? .home
        buttonsStackView.arrangedSubviews.forEach { button in
            let tab = MainTab(rawValue: button.tag)
            button.tintColor = tab == selectedTab ? UIColor(hex: "#26273C") : UIColor(hex: "#CED0DE")
        }
        delegate?.didSelectTab(selectedTab)
    }
    
}
