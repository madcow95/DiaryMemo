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
                print(todo)
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
        case .clearPhotos:
            newState.selectedPhotos = []
        case .savePhotos(let images):
            let dateStr = newState.selectedDate.dateToString(includeDay: .day)
            let photoInfo = images.enumerated().map { ($1, "\(dateStr)-\($0)") }
            
            FirebaseService.shared.savePhotos(photoInfo: photoInfo,
                                              date: dateStr) { result in
                switch result {
                case .success(let urls):
                    print("이미지 url -> \(urls)")
                    if var todo = newState.createdTodo {
                        todo.photoPath = urls
                        CoreDataService.shared.editTodo(todo: todo)
                    }
                case .failure(let error):
                    print("이미지 업로드 실패 -> \(error.localizedDescription)")
                }
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
