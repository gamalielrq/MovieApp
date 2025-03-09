//
//  MovieEntity+CoreDataProperties.swift
//  MovieApp
//
//  Created by Gama rodriguez quintero on 08/03/25.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double

}

extension MovieEntity : Identifiable {

}
