//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Gama rodriguez quintero on 07/03/25.
//

import UIKit
import SnapKit
import Combine

//TODO: modificar para que sea la vista de peliculas

class HomeViewController: UIViewController {
    
    private let viewModel: MovieViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var popularMovies: [Movie] = []
    private var topRatedMovies: [Movie] = []
    private var recommendedMovies: [Movie] = []
    
    // Inyectamos el ViewModel con el servicio deseado
    init(movieService: MovieServiceProtocol) {
        self.viewModel = MovieViewModel(movieService: movieService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchPopularMovies()
        viewModel.fetchTopRatedMovies()
        viewModel.fetchRecommendedMovies()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        tableView.backgroundColor = .clear
        title = "Películas"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.$popularMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.popularMovies = movies
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$topRatedMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.topRatedMovies = movies
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$recommendedMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.recommendedMovies = movies
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return popularMovies.count
        case 1: return topRatedMovies.count
        case 2: return recommendedMovies.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemGray5
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        
        switch section {
        case 0: titleLabel.text = "📢 Películas más Populares"
        case 1: titleLabel.text = "⭐ Más Calificadas"
        case 2: titleLabel.text = "🎯 Con Mejores Recomendaciones"
        default: titleLabel.text = ""
        }
        
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let movie: Movie
        switch indexPath.section {
        case 0: movie = popularMovies[indexPath.row]
        case 1: movie = topRatedMovies[indexPath.row]
        case 2: movie = recommendedMovies[indexPath.row]
        default: fatalError("Sección inválida")
        }
        
        cell.textLabel?.text = movie.title
        return cell
    }
}
