//
//  CointDetailSegmentedControl.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 14.03.2025.
//

import UIKit

protocol CointDetailSegmentedControlDelegate: AnyObject {
    func didSelect(state: PercetageState)
}

final class CointDetailSegmentedControl: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CointDetailSegmentedControlDelegate?
    
    private var selectedState = PercetageState.day
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var selectionView: UIView = {
        let view = UIView(frame: CGRect(x: 4, y: 4, width: 70, height: 48))
        view.layer.cornerRadius = 25
        view.backgroundColor = UIColor(hex: "FDFDFD")
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 30
        backgroundColor = UIColor(hex: "#EBEFF1")
        setupUI()
        setupConstraints()
        makeButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(selectionView)
        addSubview(stackView)
    }
    
    func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    func makeButtons() {
        for state in PercetageState.allCases {
            let button =  UIButton()
            button.setTitle(state.title, for: .normal)
            let color = state == selectedState ? UIColor(hex: "#191C32") : UIColor(hex: "#9395A5")
            button.setTitleColor(color, for: .normal)
            button.tag = state.rawValue
            button.addTarget(self, action: #selector(didTapButton(_ :)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - User Actions
    
    @objc
    private func didTapButton(_ sender: UIButton) {
        selectedState = PercetageState(rawValue: sender.tag) ?? .day
        
        stackView.arrangedSubviews.forEach { button in
            let state = PercetageState(rawValue: button.tag)
            let color = state == selectedState ? UIColor(hex: "#191C32") : UIColor(hex: "#9395A5")
            (button as? UIButton)?.setTitleColor(color, for: .normal)
            
            if state == selectedState {
                UIView.animate(withDuration: 0.3) {
                    self.selectionView.frame = CGRect(
                        x: button.frame.minX + 4,
                        y: 4,
                        width: 70,
                        height: 48
                    )
                }
            }
        }
        delegate?.didSelect(state: selectedState)
    }
    
}
