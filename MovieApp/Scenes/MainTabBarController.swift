//
//  MainTabBarController.swift
//  MovieApp
//
//  Created by Gama rodriguez quintero on 08/03/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        self.selectedIndex = 1
    }
    
    private func setupTabs() {
        
        let provisionalUser: User = User(id: 1, name: "Test User", profilePath: nil, reviews: [])
        let profileVC = UINavigationController(rootViewController: ProfileViewController(user: provisionalUser))
        let useMockData = false // Cambiar a false para usar Servicio real o poner en true para usar el mock
        let movieService: MovieServiceProtocol = useMockData ? MockMovieService() : MovieService()
        let moviesVC = UINavigationController(rootViewController: HomeViewController(movieService: movieService))
        let mapVC = UINavigationController(rootViewController: MapViewController())
        let uploadVC = UINavigationController(rootViewController: UploadViewController())
        
        profileVC.tabBarItem = UITabBarItem(title: "Perfil", image: UIImage(systemName: "person.crop.circle"), tag: 0)
        moviesVC.tabBarItem = UITabBarItem(title: "Películas", image: UIImage(systemName: "film"), tag: 1)
        mapVC.tabBarItem = UITabBarItem(title: "Mapa", image: UIImage(systemName: "map"), tag: 2)
        uploadVC.tabBarItem = UITabBarItem(title: "Subir", image: UIImage(systemName: "arrow.up.doc"), tag: 3)
        
        self.viewControllers = [profileVC, moviesVC, mapVC, uploadVC]
        self.tabBar.tintColor = .systemBlue
        self.tabBar.backgroundColor = .white
    }
}
