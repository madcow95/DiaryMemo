import UIKit
import ReactorKit
import CoreData

class CoreDataService {
    static let shared = CoreDataService()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveTodo(todo: Todo) -> Observable<Void> {
        return Observable.create { observer in
            self.context.insert(todo)
            print(todo.toTodoModel())
            do {
                try self.context.save()
                observer.onNext(())
                observer.onCompleted()
                print("저장 완료!")
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func loadTodoBy(date: String) -> Observable<TodoModel?> {
        return Observable.create { observer in
            let request = Todo.fetchRequest()
            request.predicate = NSPredicate(format: "date == %@", date)
            do {
                let todos = try self.context.fetch(request)
                print(todos.first?.toTodoModel() ?? "데이터 없음")
                observer.onNext(todos.first?.toTodoModel())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func loadTodosBy(yearMonth: String) -> Observable<[TodoModel]> {
        return Observable.create { observer in
            let request = Todo.fetchRequest()
            request.predicate = NSPredicate(format: "date CONTAINS %@", yearMonth)
            do {
                let todos = try self.context.fetch(request)
                print(#function, #line)
                print(todos.count)
                print(#function, #line)
                observer.onNext(todos.map { $0.toTodoModel() })
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func deleteAllData() -> Observable<Void> {
        return Observable.create { observer in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Todo.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try self.context.execute(deleteRequest)
                try self.context.save()
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
