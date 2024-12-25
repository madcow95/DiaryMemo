import UIKit

final class AddTodoCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: HomeCoorinator?
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let reactor = AddTodoReactor(addTodoCoordinator: self)
        let addVC = AddTodoViewController()
        addVC.reactor = reactor
        navigationController.pushViewController(addVC, animated: true)
    }
    
    func showEmotionSelectView() {
        let reactor = EmotionReactor()
        let emotionVC = EmotionViewController()
        emotionVC.reactor = reactor
        navigationController.present(emotionVC, animated: true)
    }
    
    func finish() {
        parentCoordinator?.childDidFinish(self)
    }
}
