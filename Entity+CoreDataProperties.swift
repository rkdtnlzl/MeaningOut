//
//  Entity+CoreDataProperties.swift
//  MeaningOut
//
//  Created by 강석호 on 6/15/24.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var index: Int32
    @NSManaged public var term: String?

}

extension Entity : Identifiable {

}
