import UIKit

final class EmotionCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: AddTodoCoordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
}
