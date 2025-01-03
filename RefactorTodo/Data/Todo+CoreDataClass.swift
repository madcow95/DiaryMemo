import Foundation
import CoreData

@objc(Todo)
public class Todo: NSManagedObject {

}

struct TodoModel {
    let id: String
    let date: String
    let content: String
    let emotion: String
    let photoPath: String
}

extension Todo {
    func toTodoModel() -> TodoModel {
        return TodoModel(id: self.id,
                         date: self.date,
                         content: self.content,
                         emotion: self.emotion,
                         photoPath: self.photoPath)
    }
}
