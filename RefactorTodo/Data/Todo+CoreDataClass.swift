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

public enum FontCase: Int, CaseIterable {
    case smallest
    case smaller
    case small
    case normal
    case large
    case larger
    case largest
    
    init?(index: Int) {
        self.init(rawValue: index)
    }
}
