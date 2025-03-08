//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Gama rodriguez quintero on 07/03/25.
//

import Foundation

class MovieViewModel: ObservableObject {
    
    private let movieService: MovieServiceProtocol
    
    @Published var popularMovies: [Movie] = []
    @Published var topRatedMovies: [Movie] = []
    @Published var recommendedMovies: [Movie] = []
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }
    
    func fetchPopularMovies() {
        Task {
            do {
                let movies = try await movieService.fetchPopularMovies()
                DispatchQueue.main.async {
                    self.popularMovies = movies
                }
            } catch {
                print("❌ Error al obtener películas populares: \(error)")
            }
        }
    }
    
    func fetchTopRatedMovies() {
        Task {
            do {
                let movies = try await movieService.fetchTopRatedMovies()
                DispatchQueue.main.async {
                    self.topRatedMovies = movies
                }
            } catch {
                print("❌ Error al obtener películas más calificadas: \(error)")
            }
        }
    }
    
    func fetchRecommendedMovies() {
        Task {
            do {
                let movies = try await movieService.fetchRecommendedMovies()
                DispatchQueue.main.async {
                    self.recommendedMovies = movies
                }
            } catch {
                print("❌ Error al obtener películas recomendadas: \(error)")
            }
        }
    }
}
