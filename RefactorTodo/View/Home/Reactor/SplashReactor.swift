import Foundation
import RxSwift
import ReactorKit

class SplashReactor: Reactor {
    weak var splashCoordinator: SplashCoordinator?
    
    init(splashCoordinator: SplashCoordinator?) {
        self.splashCoordinator = splashCoordinator
    }
    
    struct State {
        
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
    
    var initialState: State = State()
}
