import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController(rootViewController: HomeViewController())
    }
    
    func start() {
        let homeCoordinator = HomeCoorinator(tabBarController: self.navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

