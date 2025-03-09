//
//  SplashViewController.swift
//  MovieApp
//
//  Created by Gama rodriguez quintero on 08/03/25.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Movie App"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "reviewer1")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let developerLabel: UILabel = {
        let label = UILabel()
        label.text = "Develop by: Gamaliel Rodriguez"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "gamaliel.rq@gmail.com"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigateToHome()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [appNameLabel, imageView, developerLabel, emailLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func navigateToHome() {
        let homeViewController = MainTabBarController()
        homeViewController.modalTransitionStyle = .crossDissolve
        homeViewController.modalPresentationStyle = .fullScreen
        present(homeViewController, animated: true, completion: nil)
    }
}
