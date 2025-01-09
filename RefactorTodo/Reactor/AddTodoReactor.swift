import UIKit
import SnapKit
import ReactorKit

class AddTodoReactor: Reactor {
    let initialState: State
    weak var addTodoCoordinator: AddTodoCoordinator?
    
    init(addTodoCoordinator: AddTodoCoordinator, selectedDate: Date) {
        self.addTodoCoordinator = addTodoCoordinator
        self.initialState = State(selectedDate: selectedDate, selectedPhotos: [])
    }
    
    struct State {
        var createdTodo: TodoModel?
        var selectedDate: Date
        var selectedImageIndex: Int?
        var existTodo: TodoModel?
        var selectedPhotos: [UIImage]
    }
    
    enum Action {
        case addTodo(TodoModel, [UIImage])
        case deleteTodo(TodoModel)
        case loadTodo(Date)
        case showEmotionView(Date)
        case updateEmotionIndex(Int)
        case showPhotoLibrary
        case imageSelected([UIImage])
        case deleteImage(Int)
        case loadImages([Data]?)
        case clearPhotos
        case none
    }
    
    enum Mutation {
        case addTodo(TodoModel)
        case deleteTodo(TodoModel)
        case loadTodo(TodoModel?)
        case showEmotionView(Date)
        case updateEmotionIndex(Int)
        case showPhotoLibrary
        case imageSelected([UIImage])
        case deleteImage(Int)
        case loadImages([UIImage])
        case clearPhotos
        case savePhotos([UIImage])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addTodo(let newTodo, let images):
            return .concat([
                CoreDataService.shared.saveTodo(todo: newTodo)
                    .map { Mutation.addTodo(newTodo) }
                    .do(onNext: { [weak self] _ in
                        self?.popViewController()
                    }),
                .just(.savePhotos(images))
            ])
        case .deleteTodo(let todo):
            return CoreDataService.shared.deleteTodoForReactor(todo: todo)
                .map { Mutation.deleteTodo(todo) }
                .do(onNext: { [weak self] _ in
                    self?.popViewController()
                })
        case .loadTodo(let date):
            return CoreDataService.shared.loadTodoBy(date: date.dateToString(includeDay: .day))
                .map { Mutation.loadTodo($0) }
        case .showEmotionView(let date):
            self.addTodoCoordinator?.showEmotionSelectView(date: date)
            return .empty()
        case .updateEmotionIndex(let index):
            return .just(.updateEmotionIndex(index))
        case .showPhotoLibrary:
            return .just(.showPhotoLibrary)
        case .imageSelected(let images):
            return .just(.imageSelected(images))
        case .deleteImage(let index):
            return .just(.deleteImage(index))
        case .loadImages(let images):
            if let imgDatas = images {
                let images = imgDatas.compactMap { UIImage(data: $0) }
                return .just(.loadImages(images))
            }
            return .empty()
        case .clearPhotos:
            return .just(.clearPhotos)
        default:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .addTodo(let todo):
            newState.createdTodo = todo
        case .loadTodo(let todo):
            if let todo = todo {
                newState.existTodo = todo
            } else {
                self.addTodoCoordinator?.showEmotionSelectView(date: newState.selectedDate)
            }
        case .updateEmotionIndex(let index):
            newState.selectedImageIndex = index
        case .showPhotoLibrary:
            self.addTodoCoordinator?.showPhotoLibaryView(photo: newState.selectedPhotos.count)
        case .imageSelected(let images):
            newState.selectedPhotos += images
        case .deleteImage(let index):
            newState.selectedPhotos.remove(at: index)
        case .loadImages(let images):
            newState.selectedPhotos = images
        case .clearPhotos:
            newState.selectedPhotos = []
        case .savePhotos(let images):
            let imageDatas = images.map { img -> Data? in
                guard let data = img.jpegData(compressionQuality: 0.5) else { return nil }
                
                return data
            }.compactMap { $0 }
            
            if var todo = newState.createdTodo, imageDatas.count > 0 {
                todo.images = imageDatas
                
                CoreDataService.shared.editTodo(todo: todo)
            }
        default:
            break
        }
        
        return newState
    }
    
    func popViewController() {
        addTodoCoordinator?.finish()
    }
}
