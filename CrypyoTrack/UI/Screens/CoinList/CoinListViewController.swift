//
//  CoinListViewController.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 11.03.2025.
//
import UIKit
import SnapKit

struct CoinListViewModel {
    let coinViewModels: [CoinCellModel]
}

protocol CoinListView: AnyObject {
    var onViewDidLoad: (() -> Void)? { get set }
    var onCoinSelected: ((UUID) -> Void)? { get set }
    var onReloadTapped: (() -> Void)? { get set }
    var onLogoutTapped: (() -> Void)? { get set }
    var onSortTapped: (() -> Void)? { get set }
    
    func display(viewModel: CoinListViewModel)
    func beginRefreshing()
    func endRefreshing()
}

class CoinListViewController: UIViewController {
    
    // MARK: Properties
    
    var onViewDidLoad: (() -> Void)?
    var onCoinSelected: ((UUID) -> Void)?
    var onReloadTapped: (() -> Void)?
    var onLogoutTapped: (() -> Void)?
    var onSortTapped: (() -> Void)?
    
    private let retain: Any
    private var coinViewModels: [CoinCellModel] = []
    
    private lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.clipsToBounds = false
        return headerView
    }()
    
    private lazy var objectUIImage: UIImageView = {
        let image = UIImageView(image: .object)
        return image
    }()
    
    private lazy var affilateLabel: UILabel = {
        let label = UILabel()
        label.text = "Affiliate program"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor(hex: "#FFFFFF")
        return label
    }()
    
    private lazy var learnMoreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FAFBFB")
        return button
    }()
    
    private lazy var learnMoreTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "Learn more"
        label.textColor = UIColor(hex: "#26273C")
        return label
    }()
    
    private lazy var tableContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F7F7FA")
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 40
        return view
    }()
    
    private lazy var tableHeaderView = UIView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CoinCell.self, forCellReuseIdentifier: "CustomCoinCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var homeLabel: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        return indicator
    }()
    
    private lazy var menuButton: UIButton = {
        let reloadAction = UIAction(
            title: "Reload",
            image: UIImage(named: "rocket")
        ) { [weak self] _ in
            self?.onReloadTapped?()
        }
        let logoutAction = UIAction(
            title: "Logout",
            image: UIImage(named: "trash")
        ) { [weak self] _ in
            self?.onLogoutTapped?()
        }
        let menu = UIMenu(children: [reloadAction, logoutAction])
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.tintColor = UIColor(hex: "#191C32")
        button.backgroundColor = UIColor(hex: "#FAFBFB")
        button.layer.cornerRadius = 24
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private lazy var trendingLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending"
        label.textColor = UIColor(hex: "#191C32")
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "sort")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return button
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
        setupUI()
        onViewDidLoad?()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        learnMoreButton.layer.cornerRadius = learnMoreButton.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "customPink")
        
        view.addSubview(headerView)
        view.addSubview(tableContainerView)
        headerView.addSubview(homeLabel)
        headerView.addSubview(menuButton)
        headerView.addSubview(affilateLabel)
        headerView.addSubview(learnMoreButton)
        headerView.addSubview(objectUIImage)
        
        tableView.addSubview(activityIndicator)
        
        tableContainerView.addSubview(tableHeaderView)
        tableContainerView.addSubview(tableView)
        
        tableHeaderView.addSubview(trendingLabel)
        tableHeaderView.addSubview(sortButton)
        
        learnMoreButton.addSubview(learnMoreTitleLabel)
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(266)
        }
        
        tableContainerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).inset(40)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tableHeaderView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(70)
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(tableHeaderView.snp.bottom)
        }
        
        homeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(menuButton)
            make.leading.equalToSuperview().offset(25)
        }
        
        menuButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-25)
            make.size.equalTo(48)
        }
        
        affilateLabel.snp.makeConstraints { make in
            make.top.equalTo(homeLabel.snp.bottom).offset(46)
            make.leading.equalToSuperview().offset(25)
        }
        
        learnMoreButton.snp.makeConstraints { make in
            make.top.equalTo(affilateLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(25)
        }
        
        learnMoreTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(23)
            make.verticalEdges.equalToSuperview().inset(7)
        }
        
        objectUIImage.snp.makeConstraints { make in
            make.centerY.equalTo(tableContainerView.snp.top).offset(-35)
            make.trailing.equalToSuperview()
            make.height.equalTo(242)
        }
        
        trendingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(24)
        }
        
        sortButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(25)
            make.centerY.equalTo(trendingLabel)
            make.size.equalTo(24)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
       
    }
    
    // MARK: - User Actions
    
    @objc private func sortButtonTapped() {
        onSortTapped?()
    }
    
}



extension CoinListViewController: CoinListView {
    
    // MARK: - CoinListView
    
    func display(viewModel: CoinListViewModel) {
        self.coinViewModels = viewModel.coinViewModels
        tableView.reloadData()
    }
    
    func beginRefreshing() {
        activityIndicator.startAnimating()
    }
    
    func endRefreshing() {
        activityIndicator.stopAnimating()
    }
    
}



extension CoinListViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCoinCell", for: indexPath) as? CoinCell else {
            return UITableViewCell()
        }
        let coinViewModel = coinViewModels[indexPath.row]
        cell.configure(with: coinViewModel)
        return cell
    }
    
}



extension CoinListViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = coinViewModels[indexPath.row].id
        onCoinSelected?(id)
    }
    
}

