import Foundation
import RxSwift
import ReactorKit

class HomeReactor: Reactor {
    weak var homeCoordinator: HomeCoorinator?
    
    init(homeCoordinator: HomeCoorinator?) {
        self.homeCoordinator = homeCoordinator
    }
    
    enum Action {
        case moveToAddView(Date)
        case addTodo
    }
    
    enum Mutation {
        case moveToAddView(Date)
        case addTodo
    }
    
    struct State {
        var isAddViewPresent: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .moveToAddView(let date):
            homeCoordinator?.moveToAddTodo(selected: date)
            return .empty()
        case .addTodo:
            return .empty()
        }
    }
    
    let initialState: State = State()
}
