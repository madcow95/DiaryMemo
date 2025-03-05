import UIKit

class SplashCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let splashVC = SplashViewController()
        let splashReactor = SplashReactor(splashCoordinator: self)
        splashVC.reactor = splashReactor
        
        navigationController.viewControllers = [splashVC]
    }
    
    func moveToHomeView() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}
