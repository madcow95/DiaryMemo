import UIKit

final class AddTodoCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: HomeCoorinator?
    let selectedDate: Date
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, selectedDate: Date) {
        self.navigationController = navigationController
        self.selectedDate = selectedDate
    }
    
    func start() {
        let reactor = AddTodoReactor(addTodoCoordinator: self, selectedDate: selectedDate)
        let addVC = AddTodoViewController()
        addVC.reactor = reactor
        navigationController.pushViewController(addVC, animated: true)
    }
    
    func showEmotionSelectView(date: Date) {
        let reactor = EmotionReactor(selectedDate: date)
        let emotionVC = EmotionViewController()
        emotionVC.reactor = reactor
        navigationController.present(emotionVC, animated: true)
    }
    
    func finish() {
        parentCoordinator?.childDidFinish(self)
    }
}
