//
//  MockMovieService.swift
//  MovieApp
//
//  Created by Gama rodriguez quintero on 07/03/25.
//

import Foundation

class MockMovieService: MovieServiceProtocol {
    
    func fetchPopularMovies() async throws -> [Movie] {
        return MockDataLoader.loadMockMovies()
    }
    
    func fetchTopRatedMovies() async throws -> [Movie] {
        return MockDataLoader.loadMockTopRatedMovies()
    }
    
    func fetchRecommendedMovies() async throws -> [Movie] {
        return MockDataLoader.loadMockRecommendedMovies()
    }
}
