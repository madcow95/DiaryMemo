import UIKit

final class AddTodoCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: HomeCoorinator?
    let selectedDate: Date
    let navigationController: UINavigationController
    
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
        let addTodoReactor = navigationController.viewControllers
            .compactMap { ($0 as? AddTodoViewController)?.reactor }
            .first
        
        let emotionReactor = EmotionReactor(selectedDate: date)
        emotionReactor.addTodoReactor = addTodoReactor
        let emotionVC = EmotionViewController()
        emotionVC.reactor = emotionReactor
        
        navigationController.present(emotionVC, animated: true)
    }
    
    func finish() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
