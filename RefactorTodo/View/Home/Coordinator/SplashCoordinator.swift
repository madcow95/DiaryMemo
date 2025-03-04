import UIKit

class SplashCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let initialNavigationController: UINavigationController
    
    init() {
        self.initialNavigationController = UINavigationController()
    }
    
    func start() {
        let splashVC = SplashViewController()
        let splashReactor = SplashReactor(splashCoordinator: self)
        splashVC.reactor = splashReactor
        
        self.initialNavigationController.viewControllers = [splashVC]
    }
    
    func moveToHomeView() {
        
    }
}
