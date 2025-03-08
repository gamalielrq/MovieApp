//
//  CoreDataManager.swift
//  MovieApp
//
//  Created by Gama rodriguez quintero on 08/03/25.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MovieAppModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Error al cargar Core Data: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Guardar contexto
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Error al guardar en Core Data: \(error)")
            }
        }
    }
}



extension CoreDataManager {
    
    // Guardar películas en Core Data
    func saveMovies(_ movies: [Movie]) {
        let context = self.context
        for movie in movies {
            let movieEntity = MovieEntity(context: context)
            movieEntity.id = Int64(movie.id)
            movieEntity.title = movie.title
            movieEntity.overview = movie.overview
            movieEntity.posterPath = movie.posterPath
            movieEntity.voteAverage = movie.voteAverage
        }
        saveContext()
    }
    
    // Obtener películas desde Core Data
    func fetchMovies() -> [Movie] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            let movieEntities = try context.fetch(request)
            return movieEntities.map { entity in
                return Movie(
                    id: Int(entity.id),
                    title: entity.title ?? "",
                    overview: entity.overview ?? "",
                    posterPath: entity.posterPath,
                    voteAverage: entity.voteAverage
                )
            }
        } catch {
            print("❌ Error al obtener películas desde Core Data: \(error)")
            return []
        }
    }
}
