import Foundation
import RxSwift
import ReactorKit

final class SplashReactor: Reactor {
    var splashCoordinator: SplashCoordinator
    
    init(splashCoordinator: SplashCoordinator) {
        self.splashCoordinator = splashCoordinator
    }
    
    struct State {
        
    }
    
    enum Action {
        case moveToHomeView
    }
    
    enum Mutation {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .moveToHomeView:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.splashCoordinator.navigationController.navigationBar.isHidden = false
                self.splashCoordinator.navigationController.viewControllers.removeFirst()
                self.splashCoordinator.moveToHomeView()
            }
            
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
    
    var initialState: State = State()
}
