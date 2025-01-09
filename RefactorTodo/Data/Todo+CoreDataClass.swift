//
//  Todo+CoreDataClass.swift
//  RefactorTodo
//
//  Created by MadCow on 2025/1/9.
//
//

import UIKit
import CoreData

@objc(Todo)
public class Todo: NSManagedObject {

}

struct TodoModel {
    let date: String
    let content: String
    let emotion: String
    var images: [Data]?
}

extension Todo {
    func toTodoModel() -> TodoModel {
        return TodoModel(date: self.date,
                         content: self.content,
                         emotion: self.emotion,
                         images: self.images)
    }
}
