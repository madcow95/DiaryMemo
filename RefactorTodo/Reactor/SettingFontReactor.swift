import RxSwift
import ReactorKit

class SettingFontReactor: Reactor {
    
    weak var parentCoordinator: SettingCoordinator?
    
    init(parentCoordinator: SettingCoordinator? = nil) {
        self.parentCoordinator = parentCoordinator
    }
    
    struct State {
        var currentFontSize: FontCase = .normal
    }
    
    enum Action {
        case loadFontSize
        case changeFontSize(FontCase)
    }
    
    enum Mutation {
        case changeFontSize(FontCase)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadFontSize:
            // MARK: TODO - userDefault에 저장된 폰트사이즈 정보 불러오는 로직 추가
            return .just(.changeFontSize(.normal))
        case .changeFontSize(let fontCase):
            return .just(.changeFontSize(fontCase))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .changeFontSize(let fontSize):
            newState.currentFontSize = fontSize
        }
        
        return newState
    }
    
    let initialState: State = State()
}
