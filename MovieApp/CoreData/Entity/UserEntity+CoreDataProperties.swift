//
//  UserEntity+CoreDataProperties.swift
//  MovieApp
//
//  Created by Gama rodriguez quintero on 08/03/25.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var profilePath: String?
    @NSManaged public var reviews: String?

}
