//
//  DetailFilmVC.swift
//  VoioFilmsApp
//
//  Created by Evhen Lukhtan on 31.03.2023.
//

import UIKit
import Kingfisher

class DetailsFilmVC: UIViewController {

    // MARK: - UI
    private let contentView = UIView()
    
    private let blurImage = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    private let image = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
    }
    
    private let scoreStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
    }
    
    // Score UI
    private let scoreName = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .white.withAlphaComponent(0.5)
        $0.text = "Score:"
    }
    private let score = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title2)
        $0.textColor = .white
    }
    // Raiting UI
    private let raitingStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
    }
    
    private let raitingName = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .white.withAlphaComponent(0.5)
        $0.text = "Raiting:"
    }
    private let raiting = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title2)
        $0.textColor = .white
    }
    // Release Date UI
    private let releaseStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
    }
    
    private let releaseName = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .white.withAlphaComponent(0.5)
        $0.text = "Release Date:"
    }
    private let releaseDate = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title2)
        $0.textColor = .white
    }
    
    private let filmDescrip = UITextView().then {
        $0.font = .preferredFont(forTextStyle: .body)
        $0.backgroundColor = .clear
        $0.textColor = .white
    }
    
    private let filmName = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title1)
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.5)
    }
    private let divider2 = UIView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.5)
    }
    
    // MARK: - Properties
    private let film: Film
    
    // MARK: - Initialization
    init(film: Film) {
        self.film = film
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    // MARK: - Private functions
    private func setupNavigationBar() {
        title = film.title
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func downloadImage(`with` urlString : String){
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
                self .contentView.backgroundColor = UIColor(patternImage: value.image)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurImage.addSubview(blurEffectView)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.addSubview(blurImage)
        blurImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        let url = URL(string: "https://image.tmdb.org/t/p/w342/" + (film.posterPath ?? ""))
        blurImage.kf.setImage(with: url)
        addBlurEffect()
        
        //Image
        contentView.addSubview(image)
        image.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.width.equalTo(view.frame.width / 1.8)
            $0.height.equalTo(view.frame.height / 3)
        }
        image.kf.setImage(with: url)
        
        contentView.addSubview(scoreStackView)
        scoreStackView.snp.makeConstraints {
            $0.left.equalTo(image.snp.right).offset(16)
            $0.right.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(32)
            $0.height.equalTo(50)
        }
        score.text = String(film.voteAverage)
        [scoreName, score].forEach(scoreStackView.addArrangedSubview)
        
        contentView.addSubview(raitingStackView)
        raitingStackView.snp.makeConstraints {
            $0.left.equalTo(image.snp.right).offset(16)
            $0.centerY.equalTo(image.snp.centerY)
            $0.right.equalToSuperview().offset(16)
            $0.height.equalTo(50)
        }
        raiting.text = String(film.popularity)
        [raitingName, raiting].forEach(raitingStackView.addArrangedSubview)
        
        contentView.addSubview(releaseStackView)
        releaseStackView.snp.makeConstraints {
            $0.left.equalTo(image.snp.right).offset(16)
            $0.right.equalToSuperview().offset(16)
            $0.bottom.equalTo(image.snp.bottom)
            $0.height.equalTo(50)
        }
        releaseDate.text = String(film.releaseDate)
        [releaseName, releaseDate].forEach(releaseStackView.addArrangedSubview)
        
        // Film name
        contentView.addSubview(filmName)
        filmName.text = "Descriprion"
        filmName.snp.makeConstraints {
            $0.left.right.equalToSuperview().offset(16)
            $0.top.equalTo(image.snp.bottom).offset(16)
        }
        contentView.addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.equalTo(filmName.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(divider2)
        divider2.snp.makeConstraints {
            $0.bottom.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        // Film Description
        contentView.addSubview(filmDescrip)
        filmDescrip.text = film.overview + film.overview
        filmDescrip.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(divider2.snp.top).offset(-16)
        }
    }
    
}
