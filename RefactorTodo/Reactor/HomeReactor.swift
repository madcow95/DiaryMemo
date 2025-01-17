import Foundation
import RxSwift
import ReactorKit

class HomeReactor: Reactor {
    weak var homeCoordinator: HomeCoordinator?
    
    init(homeCoordinator: HomeCoordinator?) {
        self.homeCoordinator = homeCoordinator
    }
    
    struct State {
        var isAddViewPresent: Bool = false
        var existTodos: [TodoModel] = []
    }
    
    enum Action {
        case moveToAddView(Date)
        case moveToSearch
        case loadAllTodosByYearMonth(Date)
        case moveToSetting
    }
    
    enum Mutation {
        case loadAllTodosByYearMonth([TodoModel])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .moveToAddView(let date):
            homeCoordinator?.moveToAddTodo(selected: date)
            return .empty()
        case .moveToSearch:
            homeCoordinator?.moveToSearch()
            return .empty()
        case .loadAllTodosByYearMonth(let date):
            return CoreDataService.shared.loadTodosBy(yearMonth: date.dateToString(includeDay: .month))
                .map { Mutation.loadAllTodosByYearMonth($0) }
        case .moveToSetting:
            homeCoordinator?.moveToSetting()
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .loadAllTodosByYearMonth(let todos):
            newState.existTodos = todos
        }
        
        return newState
    }
    
    let initialState: State = State()
}
