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
    
    enum Action {
        case addTodo
        case showEmotionView(Date)
    }
    
    enum Mutation {
        case addTodo
        case showEmotionView(Date)
    }
    
    struct State {
        var selectedDate: Date
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addTodo:
            return Observable.just(.addTodo)
        case .showEmotionView(let date):
            addTodoCoordinator?.showEmotionSelectView(date: date)
            return .empty()
        }
    }
}
