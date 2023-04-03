//
//  FilmCollectionViewCell.swift
//  VoioFilmsApp
//
//  Created by Evhen Lukhtan on 30.03.2023.
//

import UIKit
import Nuke

final class FilmCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    private let imageView = UIImageView().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray3.cgColor
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .white
    }
    private let titleLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    private let priceLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
    }

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private functions
    private func setupUI() {
        [imageView, titleLabel].forEach(contentView.addSubview)
        imageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.75)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(8)
        }
    }

    // MARK: - Public functions
    func setup(with film: Film) {
        titleLabel.text = film.title
        if let url = URL(string: "https://image.tmdb.org/t/p/w342/" + (film.posterPath ?? "")) {
            let options = Style.NukeOptions.loadingOptions
            Nuke.loadImage(with: url, options: options, into: imageView)
        } else {
            imageView.image = nil
        }
    }
}

