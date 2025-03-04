import UIKit

class SplashCoordinator: Coordinator {
    private let window: UIWindow
    var childCoordinators: [Coordinator] = []
    let initialNavigationController: UINavigationController
    
    init(window: UIWindow) {
        self.initialNavigationController = UINavigationController()
        self.window = window
    }
    
    func start() {
        let splashVC = SplashViewController()
        let splashReactor = SplashReactor(splashCoordinator: self)
        splashVC.reactor = splashReactor
        
        window.rootViewController = splashVC
        window.makeKeyAndVisible()
    }
    
    func moveToHomeView() {
        let appCoordinator = AppCoordinator(window: window/*, navigationController: initialNavigationController*/)
        appCoordinator.start()
    }
}
