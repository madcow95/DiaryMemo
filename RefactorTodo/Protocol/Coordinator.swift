import Foundation

// 기본 Coordinator protocol
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

protocol PhotoDeleteDelegate {
    func deletePhoto(index: Int)
}
