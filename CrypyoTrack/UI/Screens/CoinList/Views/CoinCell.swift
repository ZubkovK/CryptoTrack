//
//  CoinCell.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 12.03.2025.
//

import UIKit
import SnapKit

struct CoinCellModel {
    
    let id: UUID
    let name: String?
    let symbol: String?
    let imageName: String?
    let price: Decimal?
    let percentageChange: Double?
}

final class CoinCell: UITableViewCell {

    // MARK: - Properties

    private let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    private let coinNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(hex: "#26273C")
        return label
    }()

    private let coinSymbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(hex: "#9395A4")
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(hex: "#26273C")
        return label
    }()

    private let percentageChangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#9395A4")
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        selectionStyle = .none
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration

    func configure(with viewModel: CoinCellModel) {
        coinNameLabel.text = viewModel.name
        coinSymbolLabel.text = viewModel.symbol
        
        priceLabel.text = viewModel.price?.formatMoney()
        
        if let percentageChange = viewModel.percentageChange {
            if percentageChange > 0 {
                arrowImageView.image = UIImage(named: "arrowUp")
                
            } else {
                arrowImageView.image = UIImage(named: "arrowDown")
            }
            percentageChangeLabel.text = String(format: "%.1f", percentageChange) + "%"
        } else {
            percentageChangeLabel.text = nil
        }
        
        coinImageView.image = if let imageName = viewModel.imageName {
            UIImage(named: imageName)
        } else {
            nil
        }
    }

    // MARK: - Private Methods

    private func setupUI() {
        contentView.addSubview(coinImageView)
        contentView.addSubview(coinNameLabel)
        contentView.addSubview(coinSymbolLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(percentageChangeLabel)
        contentView.addSubview(arrowImageView)
        
        coinImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.verticalEdges.equalToSuperview().inset(10)
            make.size.equalTo(50)
        }
        
        coinNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(coinImageView.snp.trailing).offset(19)
            make.top.equalToSuperview().offset(10)
        }
       
        coinSymbolLabel.snp.makeConstraints { make in
            make.leading.equalTo(coinNameLabel)
            make.top.equalTo(coinNameLabel.snp.bottom).offset(3)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(25)
            make.centerY.equalTo(coinNameLabel)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalTo(percentageChangeLabel.snp.leading).offset(-4)
            make.centerY.equalTo(percentageChangeLabel)
            make.size.equalTo(12)
        }
        
        percentageChangeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(25)
            make.centerY.equalTo(coinSymbolLabel)
        }
    }
}
