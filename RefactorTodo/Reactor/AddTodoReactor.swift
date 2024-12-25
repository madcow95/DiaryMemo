import UIKit
import SnapKit
import ReactorKit

class AddTodoReactor: Reactor {
    weak var addTodoCoordinator: AddTodoCoordinator?
    
    init(addTodoCoordinator: AddTodoCoordinator) {
        self.addTodoCoordinator = addTodoCoordinator
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
    
    let initialState: State = State()
}
