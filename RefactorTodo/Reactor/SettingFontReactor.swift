import RxSwift
import ReactorKit


class SettingFontReactor: Reactor {
    
    weak var parentCoordinator: SettingCoordinator?
    
    init(parentCoordinator: SettingCoordinator? = nil) {
        self.parentCoordinator = parentCoordinator
    }
    
    struct State {
        var currentFontSize: FontCase = .normal
        var currentFont: String = "normal"
        let fonts: [(String, String)] = [("normal", "기본"),
                                         ("KyungKiCheonNyunBatang", "경기천년바탕"),
                                         ("OnGeulYipGongbuJalHajana", "온글잎 공부잘하자나"),
                                         ("OnGeulYipMitMi", "온글잎 밑미"),
                                         ("ChosunCentennial", "ChosunCentennial"),
                                         ("NanumSquareR", "NanumSquare"),
                                         ("NotoSansKR-Regular", "NotoSans"),
                                         ("Recipekorea", "Recipekorea")]
    }
    
    enum Action {
        case loadFontInfo
        case changeFontSize(FontCase)
        case changeFontSizeByButton(FontCase, FontCase.SelectCase)
    }
    
    enum Mutation {
        case changeFontCase(FontCase)
//        case changeFontName(String)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadFontInfo:
            let savedFontSize = UserInfoService.shared.getFontSize()
//            let savedFontName = UserInfoService.shared.getFontName()
            return .concat([
                .just(.changeFontCase(savedFontSize)),
//                .just(.changeFontName(savedFontName))
            ])
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
            UserInfoService.shared.saveFontSize(fontCase: fontCase)
            newState.currentFontSize = fontCase
//        case .changeFontName(let fontName):
//            newState.currentFont = fontName
        }
        
        return newState
    }
    
    let initialState: State = State()
}
