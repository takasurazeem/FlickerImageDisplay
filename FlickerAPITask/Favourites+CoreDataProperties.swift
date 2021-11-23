//
//  Favourites+CoreDataProperties.swift
//  FlickerAPITask
//
//  Created by Takasur Azeem on 23/11/2021.
//
//

import Foundation
import CoreData


extension Favourites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourites> {
        return NSFetchRequest<Favourites>(entityName: "Favourites")
    }

    @NSManaged public var imageURL: String?
    @NSManaged public var creationDate: Date?

}

extension Favourites : Identifiable {

}
