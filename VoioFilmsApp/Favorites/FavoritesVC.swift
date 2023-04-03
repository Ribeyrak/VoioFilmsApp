//
//  FavoritesVC.swift
//  VoioFilmsApp
//
//  Created by Evhen Lukhtan on 02.04.2023.
//

import UIKit
import Combine
import CombineCocoa

class FavoritesVC: UIViewController {

    var viewModel = FavoriteVM()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Вибране"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
