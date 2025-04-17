import UIKit
import ReactorKit

final class EmotionReactor: Reactor {
    weak var addTodoReactor: AddTodoReactor?
    let initialState: State
    
    init(selectedDate: Date) {
        initialState = State(selectedDate: selectedDate)
    }
    
    enum Action {
        case emotionSelect(Int)
        case presentGallery
        case imageSelected(UIImage)
    }
    
    enum Mutation {
        case emotionSelected(Int)
        case moveToPrevPage
        case imageSelected(UIImage)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .emotionSelect(let index):
            addTodoReactor?.action.onNext(.updateEmotionIndex(index))
            return .concat([
                .just(.emotionSelected(index)),
                .just(.moveToPrevPage)
            ])
        case .presentGallery:
            print("test")
            addTodoReactor?.addTodoCoordinator?.showPhotoLibaryView(photo: 4)
            return .empty()
        case .imageSelected(let image):
            return .just(.imageSelected(image))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .emotionSelected(let index):
            newState.selectedEmotionIndex = index
        case .moveToPrevPage:
            newState.emotionSelected = true
        case .imageSelected(let image):
            newState.selectedImage = image
        }
        
        return newState
    }
    
    struct State {
        var selectedDate: Date
        var selectedEmotionIndex: Int?
        var emotionSelected: Bool = false
        var emotionImages: [String] = (0..<13).map { "emoji_\($0).png" }
        var selectedImage: UIImage?
    }
}
