import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    private let tabBarController: UITabBarController
    
    init(window: UIWindow) {
        self.window = window
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let homeCoordinator = HomeCoorinator(tabBarController: self.tabBarController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
        
        configureTabBar()
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    func configureTabBar() {
        tabBarController.tabBar.tintColor = .primaryColor
    }
}

