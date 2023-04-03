//
//  ProfileInputView.swift
//  VoioFilmsApp
//
//  Created by Evhen Lukhtan on 02.04.2023.
//

import UIKit
import SnapKit
import PhoneNumberKit

final class ProfileInputView: UIView {
    enum ViewType {
        case phone
        case email
        case text
        
        var isPhone: Bool {
            self == .phone
        }
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .caption2)
    }
    private let textField = UITextField().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        $0.clipsToBounds = true
    }
    
    private lazy var phoneNumbaerTextField = PhoneNumberTextField().then {
        $0.withExamplePlaceholder = true
        $0.withFlag = true
        $0.withPrefix = true
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.clipsToBounds = true
    }
    
    private let stackView = UIStackView().then {
        $0.alignment = .leading
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    private let viewType: ViewType
    
    private let phoneKit = PhoneNumberKit()
    
    public var title: String = "" {
        willSet {
            titleLabel.text = newValue
        }
    }
    
    public var placeholder: String = "" {
        willSet {
            textField.placeholder = newValue
        }
    }
    
    public var inputText: String = "" {
        willSet {
            if viewType.isPhone {
                phoneNumbaerTextField.text = newValue
            } else {
                textField.text = newValue
            }
        }
    }
    
    init(type: ViewType = .text) {
        self.viewType = type
        super.init(frame: .zero)
        self.setupUI()
        
       
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        PhoneNumberKit.CountryCodePicker.commonCountryCodes = ["UA"]
        addSubview(stackView)
        
        [
            titleLabel,
            viewType.isPhone ? phoneNumbaerTextField : textField
        ].forEach(stackView.addArrangedSubview)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
        (viewType.isPhone ? phoneNumbaerTextField : textField).snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }
}
