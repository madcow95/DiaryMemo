import UIKit
import ReactorKit
import CoreData

final class CoreDataService {
    static let shared = CoreDataService()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// 저장된 date와 일치하는 날짜가 있으면 삭제 후 저장, 없으면 그냥 저장시킨다.
    func saveTodo(todo: TodoModel) -> Observable<Void> {
        return Observable.create { observer in
            let request = Todo.fetchRequest()
            request.predicate = NSPredicate(format: "date == %@", todo.date)
            do {
                let existTodos = try self.context.fetch(request)
                if existTodos.count > 0 {
                    existTodos.forEach { self.context.delete($0) }
                }
                
                let createTodo = Todo(context: self.context)
                createTodo.content = todo.content
                createTodo.date = todo.date
                createTodo.emotion = todo.emotion
                
                self.context.insert(createTodo)
                print(createTodo.toTodoModel())
                
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
    
    /// 날짜와 일치하는 일기의 데이터를 수정
    func editTodo(todo: TodoModel) {
        let request = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", todo.date)
        do {
            let existTodos = try self.context.fetch(request)
            if existTodos.count > 0 {
                existTodos.forEach { self.context.delete($0) }
            }
            
            let createTodo = Todo(context: self.context)
            createTodo.content = todo.content
            createTodo.date = todo.date
            createTodo.emotion = todo.emotion
            createTodo.images = todo.images
            
            self.context.insert(createTodo)
            
            try self.context.save()
            print("저장 완료!")
        } catch {
            print("저장 실패! -> \(error)")
        }
    }
    
    /// 일기를 삭제하고 상태를 return
    func deleteTodoForReactor(todo: TodoModel) -> Observable<Void> {
        return Observable.create { observer in
            let request = Todo.fetchRequest()
            request.predicate = NSPredicate(format: "date == %@", todo.date)
            do {
                let existTodos = try self.context.fetch(request)
                existTodos.forEach { self.context.delete( $0 ) }
                
                try self.context.save()
                observer.onNext(())
                observer.onCompleted()
                print("삭제 완료!")
                
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    /// date와 일치하는 일기 삭제
    func deleteTodo(date: String) {
        let request = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", date)
        
        do {
            let existTodos = try self.context.fetch(request)
            existTodos.forEach { self.context.delete( $0 ) }
            
            try self.context.save()
            print("삭제 완료!")
        } catch {
            print("삭제하는 중 에러발생")
        }
    }
    
    /// date에 맞는 일기 불러오기
    func loadTodoBy(date: String) -> Observable<TodoModel?> {
        return Observable.create { observer in
            let request = Todo.fetchRequest()
            request.predicate = NSPredicate(format: "date == %@", date)
            do {
                let todos = try self.context.fetch(request)
                print(todos.last?.toTodoModel() ?? "데이터 없음")
                observer.onNext(todos.last?.toTodoModel())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    /// 검색한 키워드로 일기 찾기
    func loadTodoBy(keyword: String) -> Observable<[TodoModel]> {
        return Observable.create { observer in
            let request = Todo.fetchRequest()
            request.predicate = NSPredicate(format: "content CONTAINS[c] %@", keyword)
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
    
    /// 연, 월에 작성된 일기 불러오기
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
    
    /// 모든 일기 삭제
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
