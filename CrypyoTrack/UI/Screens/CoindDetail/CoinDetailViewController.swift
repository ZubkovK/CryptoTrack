//
//  CoinDetailViewController.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 13.03.2025.
//

import UIKit

struct CoinDetailViewModel {
    let title: String
    let usdPrice: Decimal?
    let percent: Double
    let circulating: Double
    let marketCapUsd: Decimal
    let symbol: String
}

protocol CoinDetailView: AnyObject {
    var onViewDidLoad: (() -> Void)? { get set }
    var onPercetageStateSelected: ((PercetageState) -> Void)? { get set }
    
    func display(with model: CoinDetailViewModel)
}
class CoinDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var onViewDidLoad: (() -> Void)?
    var onPercetageStateSelected: ((PercetageState) -> Void)?
    
    private let retain: Any
    
    private lazy var backButtonView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 53, height: 44)
        
        let button = UIButton()
        button.frame = CGRect(x: 9, y: 0, width: 44, height: 44)
        button.setImage(UIImage(named: "backArrow"), for: .normal)
        button.layer.cornerRadius = 24
        button.backgroundColor = UIColor(hex: "#FDFDFD")
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        containerView.addSubview(button)
        return containerView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.textColor = UIColor(hex: "#191C32")
        return label
    }()
    
    private var percentageContainerView = UIView()
    
    private let percentageChangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(hex: "#9395A4")
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 40
        view.backgroundColor = UIColor(hex: "#FDFDFD")
        return view
    }()
    
    private lazy var bottomTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor(hex: "#191C32")
        label.text = "Market Statistic"
        return label
    }()
    
    private lazy var capitalisationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(hex: "#9395A4")
        label.text = "Market capitalization"
        return label
    }()
    
    private lazy var circulatingTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(hex: "#9395A4")
        label.text = "Circulating Suply"
        return label
    }()
    
    private lazy var capitalisationValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(hex: "#191C32")
        return label
    }()
    
    private lazy var circulatingValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(hex: "#191C32")
        return label
    }()
    
    private lazy var segmentedControl: CointDetailSegmentedControl = {
        let segmentedControl = CointDetailSegmentedControl()
        segmentedControl.delegate = self
        return segmentedControl
    }()
    
    // MARK: - Init
    
    init(retain: Any) {
        self.retain = retain
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#F3F5F6")
        setupUI()
        setupConstraints()
        setupNavigationBar()
        onViewDidLoad?()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButtonView)
        navigationController?.navigationBar.titleTextAttributes = [
            .font:  UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor(hex: "#191C32")
        ]
    }
    
    private func setupUI() {
        view.addSubview(priceLabel)
        view.addSubview(percentageContainerView)
        view.addSubview(bottomView)
        view.addSubview(segmentedControl)
        
        percentageContainerView.addSubview(percentageChangeLabel)
        percentageContainerView.addSubview(arrowImageView)
        
        bottomView.addSubview(bottomTitleLabel)
        bottomView.addSubview(capitalisationTitleLabel)
        bottomView.addSubview(circulatingTitleLabel)
        bottomView.addSubview(capitalisationValueLabel)
        bottomView.addSubview(circulatingValueLabel)
    }
    
    private func setupConstraints() {
        priceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
        }
        
        percentageContainerView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.size.equalTo(12)
        }
        
        percentageChangeLabel.snp.makeConstraints { make in
            make.leading.equalTo(arrowImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(arrowImageView)
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        bottomTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.equalToSuperview().offset(25)
        }
        
        capitalisationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomTitleLabel.snp.bottom).offset(15)
            make.leading.equalTo(bottomTitleLabel)
        }
        
        circulatingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(capitalisationTitleLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview().inset(33)
            make.leading.equalTo(bottomTitleLabel)
        }
        
        capitalisationValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(capitalisationTitleLabel)
            make.trailing.equalToSuperview().inset(25)
        }
        
        circulatingValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(circulatingTitleLabel)
            make.trailing.equalToSuperview().inset(25)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(25)
            make.top.equalTo(percentageContainerView.snp.bottom).offset(20)
        }
    }
    
    // MARK: - User Actions
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}



extension CoinDetailViewController: CoinDetailView {
    
    // MARK: - CoinDetailView
    
    func display(with model: CoinDetailViewModel) {
        title = model.title
        priceLabel.text = model.usdPrice?.formatMoney()
        percentageChangeLabel.text = String(format: "%.1f", model.percent) + "%"
        
        if model.percent > 0 {
            arrowImageView.image = UIImage(named: "arrowUp")
        } else {
            arrowImageView.image = UIImage(named: "arrowDown")
        }
        
        circulatingValueLabel.text = String(format: "%.3f", model.circulating) + " " + model.symbol
        capitalisationValueLabel.text = model.marketCapUsd.formatMoney()
    }
    
}


extension CoinDetailViewController: CointDetailSegmentedControlDelegate {
    
    // MARK: - CoinDetailView
    
    func didSelect(state: PercetageState) {
        onPercetageStateSelected?(state)
    }
    
}
