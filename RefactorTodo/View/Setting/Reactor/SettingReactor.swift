import UIKit
import ReactorKit
import RxSwift

class SettingReactor: Reactor {
    weak var settingCoordinator: SettingCoordinator?
    
    init(settingCoordinator: SettingCoordinator?) {
        self.settingCoordinator = settingCoordinator
    }
    
    struct State {
        let cellLabels: [String] = ["글자 스타일", "개인정보 처리방침", "다크 모드"]
        let cellImage: [String] = ["t.circle", "lock", "moon.fill"]
    }
    
    enum Action {
        case presentPrivatePolicy
        case showFontSettingView
        case changeAppearanceTheme
    }
    
    enum Mutation {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .presentPrivatePolicy:
            settingCoordinator?.showPrivacyPolicy()
            return .empty()
        case .showFontSettingView:
            settingCoordinator?.showFontStyleView()
            return .empty()
        case .changeAppearanceTheme:
            UserInfoService.shared.setAppearance()
            return .empty()
        }
    }
    
//    func reduce(state: State, mutation: Mutation) -> State {
//        let newState = state
//        
//        return newState
//    }
    
    let initialState: State = State()
}
