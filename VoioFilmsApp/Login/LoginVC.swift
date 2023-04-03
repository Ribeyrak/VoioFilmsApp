//
//  LoginVC.swift
//  VoioFilmsApp
//
//  Created by Evhen Lukhtan on 28.03.2023.
//

import UIKit

class LoginVC: UIViewController {

    // MARK: - Constants
    private enum Constants {
        static let firstLabel = "Registration"
        static let loginPlaceholder = "Email Address"
        static let passwordPlaceholder = "Password"
        static let buttonTitle = "Join"
        
        static let nameAlertTitle = "Warning"
        static let nameAlertMessage = "All fields must be filled"
        static let emailAlertTitle = "Incorrect email"
        static let emailAlertMessage = "Enter valid email"
        static let passwordAlertTitle = "Incorrect phone"
        static let passwordAlertMessage = "Must contain 6-12 numbers"
        
        enum DefaultsKeysText {
            static let emailField = "userEmail"
            static let passwordField = "userPassword"
        }
    }
    
    // MARK: - UI
    private let firstLabel = UILabel().then {
        $0.text = Constants.firstLabel
        $0.textColor = .black
        $0.font = .preferredFont(forTextStyle: .largeTitle)
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
    }
    
    private let emailField = CustomTextField().then {
        $0.placeholder = Constants.loginPlaceholder
    }
    
    private let passwordField = CustomTextField().then {
        $0.placeholder = Constants.passwordPlaceholder
        //$0.isSecureTextEntry = true
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = .systemGray.withAlphaComponent(0.5)
    }
    
    private let divider2 = UIView().then {
        $0.backgroundColor = .systemGray.withAlphaComponent(0.5)
    }
    
    private let joinButton = CustomButtom().then {
        $0.setTitleAndColor(Constants.buttonTitle, color: .purple)
    }
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configureAppearance()
    }
    
    // MARK: - Private functions
    private func setupUI() {
        
        view.addSubview(firstLabel)
        firstLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(44)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(divider)
        divider.snp.makeConstraints() {
            $0.height.equalTo(1)
        }
        
        view.addSubview(divider2)
        divider2.snp.makeConstraints() {
            $0.height.equalTo(1)
        }
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(divider2)

        stackView.snp.makeConstraints() {
            $0.center.equalToSuperview().offset(-88)
            $0.left.right.equalToSuperview().inset(34)
            $0.height.equalTo(96)
        }
        
        view.addSubview(joinButton)
        joinButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stackView.snp.bottom).offset(44)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(49)
        }
    }
    
    private func configureAppearance() {
        view.backgroundColor = .secondarySystemBackground
        
        navigationController?.navigationBar.isHidden = true
        joinButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        emailField.text = defaults.string(forKey: Constants.DefaultsKeysText.emailField)
        passwordField.text = defaults.string(forKey: Constants.DefaultsKeysText.passwordField)
    }
    
    // MARK: - Actions
    // TextFields Validation
    @objc func nextVC() {
        let nextVC = TabBarController()
        
        if let email = emailField.text, let password = passwordField.text {
            if email.isEmpty || password.isEmpty {
                Validator().simpleAlert(vc: self, title: Constants.nameAlertTitle, message: Constants.nameAlertMessage)
            } else {
                if !email.isValidEmail {
                    Validator().simpleAlert(vc: self, title: Constants.emailAlertTitle, message: Constants.emailAlertMessage)
                } else if !password.isValidPassword {
                    Validator().simpleAlert(vc: self, title: Constants.passwordAlertTitle, message: Constants.passwordAlertMessage)
                } else {
                    navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            defaults.set(email, forKey: Constants.DefaultsKeysText.emailField)
            defaults.set(password, forKey: Constants.DefaultsKeysText.passwordField)
            UserDefaults.standard.synchronize()
        }
    }
}
