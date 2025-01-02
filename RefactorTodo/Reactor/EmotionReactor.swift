import Foundation
import ReactorKit

class EmotionReactor: Reactor {
    let initialState: State
    
    init(selectedDate: Date) {
        initialState = State(selectedDate: selectedDate)
    }
    
    enum Action {
        case emotionSelect(Int)
    }
    
    enum Mutation {
        case emoitionSelected
    }
    
    struct State {
        var selectedDate: Date
        var isEmotionSelected: Bool = false
        var emotionImages: [String] = (1...9).map { "emoji_\($0).png" }
    }
}
