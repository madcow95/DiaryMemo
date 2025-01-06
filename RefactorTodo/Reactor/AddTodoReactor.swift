import UIKit
import SnapKit
import ReactorKit

class AddTodoReactor: Reactor {
    let initialState: State
    weak var addTodoCoordinator: AddTodoCoordinator?
    
    init(addTodoCoordinator: AddTodoCoordinator, selectedDate: Date) {
        self.addTodoCoordinator = addTodoCoordinator
        self.initialState = State(selectedDate: selectedDate)
    }
    
    struct State {
        var selectedDate: Date
        var selectedImageIndex: Int?
        var existTodo: TodoModel?
    }
    
    enum Action {
        case addTodo(TodoModel)
        case deleteTodo(TodoModel)
        case loadTodo(Date)
        case showEmotionView(Date)
        case updateEmotionIndex(Int)
        case showPhotoLibrary
        case none
    }
    
    enum Mutation {
        case addTodo(TodoModel)
        case deleteTodo(TodoModel)
        case loadTodo(TodoModel?)
        case showEmotionView(Date)
        case updateEmotionIndex(Int)
        case showPhotoLibrary
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addTodo(let newTodo):
            return CoreDataService.shared.saveTodo(todo: newTodo)
                .map { Mutation.addTodo(newTodo) }
                .do(onNext: { [weak self] _ in
                    self?.popViewController()
                })
        case .deleteTodo(let todo):
            return CoreDataService.shared.deleteTodoForReactor(todo: todo)
                .map { Mutation.deleteTodo(todo) }
                .do(onNext: { [weak self] _ in
                    self?.popViewController()
                })
        case .loadTodo(let date):
            return CoreDataService.shared.loadTodoBy(date: date.dateToString(includeDay: .day))
                .map { Mutation.loadTodo($0) }
        case .showEmotionView(let date):
            self.addTodoCoordinator?.showEmotionSelectView(date: date)
            return .empty()
        case .updateEmotionIndex(let index):
            return .just(.updateEmotionIndex(index))
        case .showPhotoLibrary:
            return .just(.showPhotoLibrary)
        default:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .loadTodo(let todo):
            if let todo = todo {
                newState.existTodo = todo
            } else {
                self.addTodoCoordinator?.showEmotionSelectView(date: newState.selectedDate)
            }
        case .updateEmotionIndex(let index):
            newState.selectedImageIndex = index
        case .showPhotoLibrary:
            self.addTodoCoordinator?.showPhotoLibaryView()
        default:
            break
        }
        
        return newState
    }
    
    func popViewController() {
        addTodoCoordinator?.finish()
    }
}
