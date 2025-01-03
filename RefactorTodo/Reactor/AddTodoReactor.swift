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
        case addTodo(Todo)
        case loadTodo(Date)
        case showEmotionView(Date)
        case updateEmotionIndex(Int)
    }
    
    enum Mutation {
        case addTodo(Todo)
        case loadTodo(TodoModel?)
        case showEmotionView(Date)
        case updateEmotionIndex(Int)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addTodo(let newTodo):
            return CoreDataService.shared.saveTodo(todo: newTodo)
                .do(onNext: { [weak self] _ in
                    self?.popViewController()
                })
                .map { Mutation.addTodo(newTodo) }
        case .loadTodo(let date):
            return CoreDataService.shared.loadTodoBy(date: date.dateToString(includeDay: .day))
                .map { Mutation.loadTodo($0) }
        case .showEmotionView(let date):
            return CoreDataService.shared.loadTodoBy(date: date.dateToString(includeDay: .day))
                .flatMap { todo -> Observable<Mutation> in
                    guard todo == nil else { return .empty() }
                    self.addTodoCoordinator?.showEmotionSelectView(date: date)
                    return .empty()
                }
        case .updateEmotionIndex(let index):
            return .just(.updateEmotionIndex(index))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .loadTodo(let todo):
            newState.existTodo = todo
        case .updateEmotionIndex(let index):
            newState.selectedImageIndex = index
        default:
            break
        }
        
        return newState
    }
    
    func popViewController() {
        addTodoCoordinator?.finish()
    }
}
