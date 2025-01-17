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
        case changeFontSizeByButton(FontCase, FontCase.SelectCase)
    }
    
    enum Mutation {
        case changeFontCase(FontCase)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadFontSize:
            // MARK: TODO - userDefault에 저장된 폰트사이즈 정보 불러오는 로직 추가
            let savedFontSize = UserInfoService.shared.getFontSize(key: "savedFontSize")
            return .just(.changeFontCase(savedFontSize))
        case .changeFontSize(let fontCase):
            return .just(.changeFontCase(fontCase))
        case .changeFontSizeByButton(let fontcase, let selectCase):
            return .just(.changeFontCase(fontcase.updateCaseBy(selectCase: selectCase)))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .changeFontCase(let fontCase):
            UserInfoService.shared.saveFontSize(fontCase: fontCase, key: "savedFontSize")
            newState.currentFontSize = fontCase
        }
        
        return newState
    }
    
    let initialState: State = State()
}
