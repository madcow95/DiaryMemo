import ReactorKit

class EmotionReactor: Reactor {
    
    enum Action {
        case emotionSelect
    }
    
    enum Mutation {
        case emoitionSelected
    }
    
    struct State {
        var isEmotionSelected: Bool = false
    }
    
    let initialState: State = State()
}
