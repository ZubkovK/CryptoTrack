//
//  AuthViewController.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 11.03.2025.
//

import UIKit

protocol AuthView: AnyObject {
    
    var onViewDidLoad: (() -> Void)? { get set }
    var onLoginTapped: (((login: String?, password: String?)) -> Void)? { get set }
    
    func showError(message: String)
}

final class AuthViewController: UIViewController {
    
    // MARK: - Properties
    
    var onViewDidLoad: (() -> Void)?
    var onLoginTapped: (((login: String?, password: String?)) -> Void)?
    
    private let retain: Any
    
    private lazy var authImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "authImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = makeInputField(
            placeholder: "Username",
            iconName: "kid",
            iconBackgroundColor: "#FFEBE4",
            isSecureTextEntry: false
        )
        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = makeInputField(
            placeholder: "Password",
            iconName: "lock",
            iconBackgroundColor: "#EBECFF",
            isSecureTextEntry: true
        )
        textField.delegate = self
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor(hex: "#191C32")
        button.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        button.layer.cornerRadius = 28
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
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
        
        onViewDidLoad?()
        setupUI()
        setupConstraints()
    }
    
    //MARK: - Private Methods 
    
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#F3F5F6")
        
        view.addSubview(authImageView)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        authImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(13)
            make.height.width.equalTo(287)
            make.centerX.equalToSuperview()
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(68)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(55)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(usernameTextField)
            make.height.equalTo(usernameTextField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.leading.trailing.equalTo(usernameTextField)
            make.height.equalTo(55)
        }
    }
    
    private func createIconView(iconName: String, backgroundColor: String) -> UIView {
        let iconView = UIImageView(image: UIImage(named: iconName))
        iconView.contentMode = .scaleAspectFit
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 10, y: 11, width: 32, height: 32)
        iconView.frame = CGRect(x: 9, y: 9, width: 14, height: 14)
        containerView.addSubview(iconView)
        containerView.layer.cornerRadius = 16
        containerView.backgroundColor = UIColor(hex: backgroundColor)
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: 62, height: 55)
        contentView.addSubview(containerView)
        
        return contentView
    }
    
    private func makeInputField(
        placeholder: String,
        iconName: String,
        iconBackgroundColor: String,
        isSecureTextEntry: Bool
    ) -> UITextField {
        let textField = UITextField()
        textField.isSecureTextEntry = isSecureTextEntry
        textField.placeholder = placeholder
        textField.leftViewMode = .always
        textField.leftView = createIconView(iconName: iconName, backgroundColor: iconBackgroundColor)
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 25
        textField.backgroundColor = UIColor(hex: "#FFFFFF")
        return textField
    }
    
    // MARK: - User Actions
    
    @objc private func loginTapped() {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text else { return }
        onLoginTapped?((login: username ,password: password))

    }
}



extension AuthViewController: AuthView {
    
    // MARK: - AuthView
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}



extension AuthViewController: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
