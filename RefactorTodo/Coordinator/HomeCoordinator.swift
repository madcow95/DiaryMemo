import UIKit

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVC = HomeViewController()
        let reactor = HomeReactor(homeCoordinator: self)
        homeVC.reactor = reactor
        
        navigationController.viewControllers = [homeVC]
    }
    
    func moveToAddTodo(selected date: Date) {
        let addTodoCoordinator = AddTodoCoordinator(navigationController: navigationController,
                                                    selectedDate: date)
        childCoordinators.append(addTodoCoordinator)
        addTodoCoordinator.parentCoordinator = self
        addTodoCoordinator.start()
    }
    
    func childDidFinish(_ child: Coordinator) {
        if let idx = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: idx)
        }
    }
}
