//
//  MockDataLoader.swift
//  MovieApp
//
//  Created by Gama rodriguez quintero on 07/03/25.
//

import Foundation

struct Review: Decodable {
    let imageName: String
    let text: String
}

struct ReviewResponse: Decodable {
    let reviews: [Review]
}

struct MovieResponse: Decodable {
    let results: [Movie]
}

class MockDataLoader {
    
    // MARK: Método genérico para cargar datos desde un archivo JSON
    private static func loadJSON<T: Decodable>(from filename: String, as type: T.Type) -> T? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("❌ No se encontró el archivo \(filename).json")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("❌ Error al cargar \(filename).json: \(error)")
            return nil
        }
    }
    
    static func loadMockMovies() -> [Movie] {
        return loadJSON(from: "mock_movies", as: MovieResponse.self)?.results ?? []
    }
    
    static func loadMockTopRatedMovies() -> [Movie] {
        return loadJSON(from: "mock_top_rated", as: MovieResponse.self)?.results ?? []
    }
    
    static func loadMockRecommendedMovies() -> [Movie] {
        return loadJSON(from: "mock_recommendations", as: MovieResponse.self)?.results ?? []
    }
    
    static func loadMockReviews() -> [Review] {
        return loadJSON(from: "mock_reviews", as: ReviewResponse.self)?.reviews ?? []
    }
}
