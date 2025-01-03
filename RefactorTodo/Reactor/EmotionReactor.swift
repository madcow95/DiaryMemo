import Foundation
import ReactorKit

class EmotionReactor: Reactor {
    weak var addTodoReactor: AddTodoReactor?
    let initialState: State
    
    init(selectedDate: Date) {
        initialState = State(selectedDate: selectedDate)
    }
    
    enum Action {
        case emotionSelect(Int)
    }
    
    enum Mutation {
        case emotionSelected(Int)
        case moveToPrevPage
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .emotionSelect(let index):
            addTodoReactor?.action.onNext(.updateEmotionIndex(index))
            return .concat([
                .just(.emotionSelected(index)),
                .just(.moveToPrevPage)
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .emotionSelected(let index):
            newState.selectedEmotionIndex = index
        case .moveToPrevPage:
            newState.emotionSelected = true
        }
        
        return newState
    }
    
    struct State {
        var selectedDate: Date
        var selectedEmotionIndex: Int?
        var emotionSelected: Bool = false
        var emotionImages: [String] = (0..<9).map { "emoji_\($0).png" }
    }
}
