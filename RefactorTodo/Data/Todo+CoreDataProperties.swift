//
//  Todo+CoreDataProperties.swift
//  RefactorTodo
//
//  Created by MadCow on 2025/1/9.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var content: String
    @NSManaged public var date: String
    @NSManaged public var emotion: String
    @NSManaged public var images: [Data]?

}

extension Todo : Identifiable {

}
