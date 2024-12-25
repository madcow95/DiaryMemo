import Foundation
import ReactorKit

class EmotionReactor: Reactor {
    
    let selectedDate: Date
    
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
    }
    
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
