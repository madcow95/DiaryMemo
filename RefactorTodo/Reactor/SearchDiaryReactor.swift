import UIKit
import RxSwift
import ReactorKit

class SearchDiaryReactor: Reactor {
    weak var homeCoordinator: HomeCoordinator?
    
    struct State {
        var searchedDiary: [TodoModel] = []
        var searchText: String = ""
    }
    
    enum Action {
        case searchDiary(String)
    }
    
    enum Mutation {
        case updateDiary([TodoModel])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchDiary(let keyword):
            if keyword.isEmpty {
                return .just(.updateDiary([]))
            } else {
                return CoreDataService.shared.loadTodoBy(keyword: keyword)
                    .flatMap { results -> Observable<Mutation> in
                        return .just(.updateDiary(results))
                    }
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateDiary(let results):
            newState.searchedDiary = results.sorted { $0.date > $1.date }
        }
        
        return newState
    }
    
    let initialState: State = State()
}
