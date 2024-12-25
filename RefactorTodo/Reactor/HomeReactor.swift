import RxSwift
import ReactorKit

class HomeReactor: Reactor {
    weak var homeCoordinator: HomeCoorinator?
    
    init(homeCoordinator: HomeCoorinator?) {
        self.homeCoordinator = homeCoordinator
    }
    
    enum Action {
        case moveToAddView
        case addTodo
    }
    
    enum Mutation {
        case moveToAddView
        case addTodo
    }
    
    struct State {
        var isAddViewPresent: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .moveToAddView:
            homeCoordinator?.moveToAddTodo()
            return .empty()
        case .addTodo:
            return .empty()
        }
    }
    
    let initialState: State = State()
}
