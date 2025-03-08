//
//  MovieService.swift
//  MovieApp
//
//  Created by Gama rodriguez quintero on 07/03/25.
//

import Foundation

class MovieService: MovieServiceProtocol {
    
    private var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String, !key.isEmpty else {
            fatalError("❌ Error: No se encontró la clave TMDB_API_KEY en Info.plist")
        }
        return key
    }
    
    private let baseURL = "https://api.themoviedb.org/3/movie"
    
    func fetchPopularMovies() async throws -> [Movie] {
        return try await fetchMovies(endpoint: "popular")
    }
    
    func fetchTopRatedMovies() async throws -> [Movie] {
        return try await fetchMovies(endpoint: "top_rated")
    }
    
    func fetchRecommendedMovies() async throws -> [Movie] {
        return try await fetchMovies(endpoint: "now_playing")
    }
    
    private func fetchMovies(endpoint: String) async throws -> [Movie] {
        guard let url = URL(string: "\(baseURL)/\(endpoint)?language=es-MX") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
        return movieResponse.results
    }
}
