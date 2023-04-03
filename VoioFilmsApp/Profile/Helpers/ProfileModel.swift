//
//  ProfileModel.swift
//  VoioFilmsApp
//
//  Created by Evhen Lukhtan on 02.04.2023.
//

import Foundation

struct ProfileModel {
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var userEmail: String
    var userPhoto: String
    var favoriteFilms: [Film]
    
    static let `default`: ProfileModel = .init(
        firstName: "First name", lastName: "Last name", phoneNumber: "+380671234567",
        userEmail: "example@mail.com", userPhoto: "", favoriteFilms: []
    )
}
