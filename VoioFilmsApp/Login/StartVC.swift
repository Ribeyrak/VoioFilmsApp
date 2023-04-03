//
//  StartVC.swift
//  VoioFilmsApp
//
//  Created by Evhen Lukhtan on 28.03.2023.
//

import UIKit
import SnapKit
import Then

final class StartVC: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let backgroundImage = "BG"
        static let firstLabel = "Voio Films"
        static let secondLabel = "Watch the best any time you want"
        static let joinButton = "Join"
        static let logInButton = "Log in"
    }
    
    // MARK: - UI
    private let backgroundImage = UIImageView().then {
        $0.image = UIImage(named: Constants.backgroundImage)
    }
    
    private let firstLabel = UILabel().then {
        $0.text = Constants.firstLabel
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 52)
    }
    
    private let secondLabel = UILabel().then {
        $0.text = Constants.secondLabel
        $0.textColor = .white
        $0.font = .preferredFont(forTextStyle: .largeTitle)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let joinButton = CustomButtom().then {
        $0.setTitleAndColor(Constants.logInButton, color: .purple)
        $0.layer.cornerRadius = 2
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureAppearance()
    }
    
    // MARK: - Private functions
    private func setupUI() {
        
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        
        view.addSubview(firstLabel)
        firstLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(88)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(secondLabel)
        secondLabel.snp.makeConstraints {
            $0.top.equalTo(firstLabel.snp.bottom).offset(38)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        view.addSubview(joinButton)
        joinButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(73)
            $0.left.right.equalToSuperview().inset(34)
            $0.height.equalTo(49)
        }
    }
    
    private func configureAppearance() {
        joinButton.addTarget(self, action: #selector(moveToJoinVC), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func moveToJoinVC() {
        let nextVC = LoginVC()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

