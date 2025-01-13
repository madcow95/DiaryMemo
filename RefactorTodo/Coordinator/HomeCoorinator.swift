import UIKit

final class HomeCoorinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(tabBarController: UINavigationController) {
        self.navigationController = tabBarController
    }
    
    func start() {
        let reactor = HomeReactor(homeCoordinator: self)
        if let homeVC = navigationController.viewControllers.first as? HomeViewController {        
            homeVC.reactor = reactor
        }
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
