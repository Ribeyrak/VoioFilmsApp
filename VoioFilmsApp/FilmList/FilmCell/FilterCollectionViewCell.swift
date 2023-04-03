//
//  FilterCollectionViewCell.swift
//  VoioFilmsApp
//
//  Created by Evhen Lukhtan on 30.03.2023.
//

import UIKit
import SnapKit

final class FilterCollectionViewCell: UICollectionViewCell {
    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(title)
        title.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
