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
                                         ("Cafe24Simplehae", "카페24 심플해"),
                                         ("Cafe24Syongsyong", "카페24 숑숑"),
                                         ("TheFaceShop", "잉크립퀴드체"),
                                         ("ChosunCentennial", "ChosunCentennial"),
                                         ("NanumSquareR", "NanumSquare"),
                                         ("NotoSansKR-Regular", "NotoSans"),
                                         ("UhBee mysen", "어비 마이센체"),
                                         ("Mabinogi_Classic", "마비옛체"),
                                         ("Recipekorea", "Recipekorea")
                                        ]
        var fontIndex: Int
        
        init() {
            let fontName = UserInfoService.shared.getFontName()
            self.fontIndex = self.fonts.firstIndex(where: { $0.0 == fontName })!
        }
    }
    
    enum Action {
        case loadFontInfo
        case changeFontSize(FontCase)
        case changeFontSizeByButton(FontCase, FontCase.SelectCase)
        case updateFontIndex(Int)
    }
    
    enum Mutation {
        case changeFontCase(FontCase)
        case updateFontIndex(Int)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadFontInfo:
            let savedFontSize = UserInfoService.shared.getFontSize()
            return .just(.changeFontCase(savedFontSize))
        case .changeFontSize(let fontCase):
            return .just(.changeFontCase(fontCase))
        case .changeFontSizeByButton(let fontcase, let selectCase):
            return .just(.changeFontCase(fontcase.updateCaseBy(selectCase: selectCase)))
        case .updateFontIndex(let index):
            return .just(.updateFontIndex(index))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .changeFontCase(let fontCase):
            UserInfoService.shared.saveFontSize(fontCase: fontCase)
            newState.currentFontSize = fontCase
        case .updateFontIndex(let index):
            newState.fontIndex = index
        }
        
        return newState
    }
    
    let initialState: State = State()
}
