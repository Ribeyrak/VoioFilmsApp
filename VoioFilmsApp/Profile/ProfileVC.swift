//
//  ProfileVC.swift
//  VoioFilmsApp
//
//  Created by Evhen Lukhtan on 01.04.2023.
//

import UIKit

class ProfileVC: UIViewController {
    
    //MARK: - UI
    private(set) lazy var phoneTextField = ProfileInputView(type: .phone).then {
        $0.title = "Телефон"
        $0.inputText = viewModel.profile.phoneNumber
    }
    private(set) lazy var emailTextField = ProfileInputView(type: .email).then {
        $0.title = "Email"
        $0.inputText = viewModel.profile.userEmail
    }
    private(set) lazy var firstNameTextField = ProfileInputView().then {
        $0.title = "Ім'я"
        $0.inputText = viewModel.profile.firstName
    }
    private(set) lazy var lastNameTextField = ProfileInputView().then {
        $0.title = "Прізвище"
        $0.inputText = viewModel.profile.lastName
    }
    
    private let logoutButton = CustomButtom().then {
        $0.setTitleAndColor("Logout", color: .systemRed)
        $0.layer.cornerRadius = 2
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }

    // MARK: - Properties
    private let viewModel = ProfileViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        setupUI()
        configureAppearance()
    }

    //MARK: - Private functions
    private func setupUI() {
        title = "Профіль"
        view.addSubview(stackView)
        
        [phoneTextField, emailTextField, firstNameTextField, lastNameTextField,
         logoutButton
        ].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(52)
            }
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(34)
            $0.left.right.equalToSuperview().inset(34)
            $0.height.equalTo(49)
        }
    }
    
    private func configureAppearance() {
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func logoutButtonTapped() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        let nextVC = UINavigationController(rootViewController: StartVC())
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController = nextVC
    }
}
