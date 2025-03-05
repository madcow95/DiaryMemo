import Foundation

// 기본 Coordinator protocol
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

// 이미지  삭제 후 동적처리를 위한 delegate
protocol PhotoDeleteDelegate {
    func deletePhoto(index: Int)
}
