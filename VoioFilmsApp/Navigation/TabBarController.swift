//
//  TabBarController.swift
//  VoioFilmsApp
//
//  Created by Evhen Lukhtan on 28.03.2023.
//

import UIKit

enum Tabs: Int, CaseIterable {
    case main
    case favorite
    case profile
}

enum TabBar {
    static func title(for tab: Tabs) -> String {
        switch tab {
            case .main: return "Головна"
            case .favorite: return "Вибране"
            case .profile: return "Профіль"
        }
    }
    
    static func icon(for tab: Tabs) -> UIImage? {
        switch tab {
        case .main: return UIImage(systemName: "film")
        case .favorite: return UIImage(systemName: "star")
        case .profile: return UIImage(systemName: "person")
        }
    }
}

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearence()
    }
    
    private func configureAppearence() {

        tabBar.tintColor = .purple
        tabBar.backgroundColor = .secondarySystemFill

        let controllers: [UINavigationController] = Tabs.allCases.map { tab in
            let controller = UINavigationController(rootViewController: getController(for: tab))
            controller.tabBarItem = UITabBarItem(title: TabBar.title(for: tab),
                                                 image: TabBar.icon(for: tab),
                                                 tag: tab.rawValue)
            return controller
        }
        setViewControllers(controllers, animated: false)
    }

    private func getController(for tab: Tabs) -> UIViewController {
        switch tab {
        case .main: return FilmsListVC()
        case .favorite: return FavoritesVC()
        case .profile: return ProfileVC()
        }
    }

}
