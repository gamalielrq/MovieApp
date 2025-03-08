//
//  MovieServiceProtocol.swift
//  MovieApp
//
//  Created by Gama rodriguez quintero on 07/03/25.
//

import Foundation
import Combine

protocol MovieServiceProtocol {
    func fetchPopularMovies() async throws -> [Movie]
    func fetchTopRatedMovies() async throws -> [Movie]
    func fetchRecommendedMovies() async throws -> [Movie]
}
