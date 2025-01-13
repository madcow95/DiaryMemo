import UIKit
import ReactorKit
import RxSwift

class SettingReactor: Reactor {
    weak var settingCoordinator: SettingCoordinator?
    
    
    init(settingCoordinator: SettingCoordinator?) {
        self.settingCoordinator = settingCoordinator
    }
    
    struct State {
        let cellLabels: [String] = ["개인정보 처리방침"]
    }
    
    enum Action {
        case presentPrivatePolicy
    }
    
    enum Mutation {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .presentPrivatePolicy:
            settingCoordinator?.showPrivacyPolicy()
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        let newState = state
        
        return newState
    }
    
    let initialState: State = State()
}
