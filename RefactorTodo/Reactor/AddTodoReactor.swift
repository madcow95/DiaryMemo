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
        case showEmotionView
    }
    
    enum Mutation {
        case addTodo
        case showEmotionView
    }
    
    struct State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addTodo:
            return Observable.just(.addTodo)
        case .showEmotionView:
            addTodoCoordinator?.showEmotionSelectView()
            return .empty()
        }
    }
    
    let initialState: State = State()
}
