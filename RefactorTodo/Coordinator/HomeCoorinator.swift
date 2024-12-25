import UIKit

final class HomeCoorinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    func start() {
        let reactor = HomeReactor(homeCoordinator: self)
        let homeVC = HomeViewController()
        homeVC.reactor = reactor
        
        let navigationVC = UINavigationController(rootViewController: homeVC)
        navigationVC.tabBarItem = UITabBarItem(title: "Home",
                                               image: UIImage(systemName: "house.fill"),
                                               selectedImage: nil)
        
        tabBarController.viewControllers = [navigationVC]
    }
    
    func moveToAddTodo() {
        guard let navigationController = tabBarController.selectedViewController as? UINavigationController else {
            return
        }
                
        let addTodoCoordinator = AddTodoCoordinator(navigationController: navigationController)
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
